
> 判断网络内容是否可达的


#ifndef _SCNETWORKREACHABILITY_H
#define _SCNETWORKREACHABILITY_H

#include <os/availability.h>
#include <TargetConditionals.h>
#include <sys/cdefs.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <CoreFoundation/CoreFoundation.h>
#include <SystemConfiguration/SCNetwork.h>
#include <dispatch/dispatch.h>

CF_IMPLICIT_BRIDGING_ENABLED
CF_ASSUME_NONNULL_BEGIN

/*!
	@header SCNetworkReachability
	@discussion The SCNetworkReachability API allows an application to
		determine the status of a system's current network
		configuration and the reachability of a target host.
		In addition, reachability can be monitored with notifications
		that are sent when the status has changed.

		"Reachability" reflects whether a data packet, sent by
		an application into the network stack, can leave the local
		computer.
		Note that reachability does <i>not</i> guarantee that the data
		packet will actually be received by the host.

		When reachability is used without scheduling updates on a runloop
		or dispatch queue, the system will not generate DNS traffic and
		will be optimistic about its reply - it will assume that the target
		is reachable if there is a default route but a DNS query is
		needed to learn the address. When scheduled, the first callback
		will behave like an unscheduled call but subsequent calls will
		leverage DNS results.

		When used on IPv6-only (NAT64+DNS64) networks, reachability checks
		for IPv4 address literals (either a struct sockaddr_in * or textual
		representations such as "192.0.2.1") will automatically give the
		result for the corresponding synthesized IPv6 address.
		On those networks, creating a CFSocketStream or NSURLSession
		to that address will send packets but trying to connect using
		BSD socket APIs will fail.
 */

/*!
	@typedef SCNetworkReachabilityRef
	@discussion This is the handle to a network address or name.
 */
typedef const struct CF_BRIDGED_TYPE(id) __SCNetworkReachability * SCNetworkReachabilityRef;

//   网络罗可达性的上下文 包括： 用户指定数据 和可达性的回调
//   version 是0 ， 是要传给SCDynamicStore 的创建方法
//   info C指针两类型， 用户指定数据的block
//   retain 持有的操作
//  release： 释放的操作
// copyDescription 回调返回描述
typedef struct {
	CFIndex		version;
	void *		__nullable info;
	const void	* __nonnull (* __nullable retain)(const void *info);
	void		(* __nullable release)(const void *info);
	CFStringRef	__nonnull (* __nullable copyDescription)(const void *info);
} SCNetworkReachabilityContext;

/*!
	@enum SCNetworkReachabilityFlags 
	// 看来很多都是可以这样去处理这个内容的， 通过移位来进行操作
	// 指定的网络节点名或地址是否可达， 是否需要连接，或者需要用户干涉去建立连接

	@constant kSCNetworkReachabilityFlagsTransientConnection
		//  临时的连接， 表示当前地址可达一个通过一个临时连接， eg：PPP（点对点）

	@constant kSCNetworkReachabilityFlagsReachable
		//  当前网络可以连接

	@constant kSCNetworkReachabilityFlagsConnectionRequired
	// 当前配置的网络需要连接， 第一次连接
	// eg：对于当前未处于活动状态但可以处理目标系统网络流量的拨号连接，将返回此状态。

	@constant kSCNetworkReachabilityFlagsConnectionOnTraffic
	//  当前网络可以自动连接
	//  kSCNetworkReachabilityFlagsConnectionAutomatic 

	@constant kSCNetworkReachabilityFlagsInterventionRequired
	//  已经第一次连接过了的， 并且当前网络可达， 需要用户干涉 eg： 密码、验证码等
	// 在过去，返回这个状态的情况是： 拨号尝试连接当前网络在连接尝试。 但是， ppp控制将停止尝试建立，知道用户干涉

	@constant kSCNetworkReachabilityFlagsConnectionOnDemand
	//  前提网络第一次连接过，并且当前是可连接的，  将会"On Demand"的方式建立通过CFSocketStream接口。其他的api将不会建立连接。

	@constant kSCNetworkReachabilityFlagsIsLocalAddress
	// 当前本地网络

	@constant kSCNetworkReachabilityFlagsIsDirect
	// 不经过网卡， 但是直接路由到系统的接口

	@constant kSCNetworkReachabilityFlagsIsWWAN
	//  EDGE, GPRS, or other "cell" 网络连接
		This flag indicates that the specified nodename or address can
		be reached via an connection.
 */
typedef CF_OPTIONS(uint32_t, SCNetworkReachabilityFlags) {
	kSCNetworkReachabilityFlagsTransientConnection		= 1<<0,
	kSCNetworkReachabilityFlagsReachable			= 1<<1,
	kSCNetworkReachabilityFlagsConnectionRequired		= 1<<2,
	kSCNetworkReachabilityFlagsConnectionOnTraffic		= 1<<3,
	kSCNetworkReachabilityFlagsInterventionRequired		= 1<<4,
	kSCNetworkReachabilityFlagsConnectionOnDemand
		API_AVAILABLE(macos(10.6),ios(3.0))		= 1<<5,
	kSCNetworkReachabilityFlagsIsLocalAddress		= 1<<16,
	kSCNetworkReachabilityFlagsIsDirect			= 1<<17,
	kSCNetworkReachabilityFlagsIsWWAN
		API_UNAVAILABLE(macos) API_AVAILABLE(ios(2.0))	= 1<<18,

	kSCNetworkReachabilityFlagsConnectionAutomatic	= kSCNetworkReachabilityFlagsConnectionOnTraffic
};

//  回调的定义
typedef void (*SCNetworkReachabilityCallBack)	(
						SCNetworkReachabilityRef			target,
						SCNetworkReachabilityFlags			flags,
						void			     *	__nullable	info
						);

__BEGIN_DECLS

//   通过地址来创建一个网络可达性的上下文
SCNetworkReachabilityRef __nullable
SCNetworkReachabilityCreateWithAddress		(
						CFAllocatorRef			__nullable	allocator,
						const struct sockaddr				*address
						)				API_AVAILABLE(macos(10.3), ios(2.0));

//   通过网络对来判断是否可达
//  localAddress：本地地址
//  remoteAddress： 远程地址
SCNetworkReachabilityRef __nullable
SCNetworkReachabilityCreateWithAddressPair	(
						CFAllocatorRef			__nullable	allocator,
						const struct sockaddr		* __nullable	localAddress,
						const struct sockaddr		* __nullable	remoteAddress
						)				API_AVAILABLE(macos(10.3), ios(2.0));

/*!
	@function SCNetworkReachabilityCreateWithName
	@discussion 通过主机名字或节点创建一个弟子那个网络的引用。 这个引用能够用于后面去控制目标主机的可达性
	@param  allocator 这里一般是默认的分配方式 kCFAllocatorDefault
	@param nodename  域名
	// 返回一个不可变的SCNetworkReachabilityRef 应用
	// 必须释放返回值
 */

SCNetworkReachabilityRef __nullable
SCNetworkReachabilityCreateWithName		(
						CFAllocatorRef			__nullable	allocator,
						const char					*nodename
						)				API_AVAILABLE(macos(10.3), ios(2.0));

//   获取类型的id
CFTypeID
SCNetworkReachabilityGetTypeID			(void)				API_AVAILABLE(macos(10.3), ios(2.0));



// 获取有关的flag
Boolean
SCNetworkReachabilityGetFlags			(
						SCNetworkReachabilityRef	target,
						SCNetworkReachabilityFlags	*flags
						)				API_AVAILABLE(macos(10.3), ios(2.0));

//  设置回调
Boolean
SCNetworkReachabilitySetCallback		(
						SCNetworkReachabilityRef			target,
						SCNetworkReachabilityCallBack	__nullable	callout,
						SCNetworkReachabilityContext	* __nullable	context
						)				API_AVAILABLE(macos(10.3), ios(2.0));

//  运行的runloop 和模式
//  target 地址或者名字， 这个不可以为空，设置用于异步通知
//  runloop  runLoopMode
//  返回是否成功

Boolean
SCNetworkReachabilityScheduleWithRunLoop	(
						SCNetworkReachabilityRef	target,
						CFRunLoopRef			runLoop,
						CFStringRef			runLoopMode
						)				API_AVAILABLE(macos(10.3), ios(2.0));

//  取消这个任务
Boolean
SCNetworkReachabilityUnscheduleFromRunLoop	(
						SCNetworkReachabilityRef	target,
						CFRunLoopRef			runLoop,
						CFStringRef			runLoopMode
						)				API_AVAILABLE(macos(10.3), ios(2.0));


//  GCD设置的队列返回的回调
Boolean
SCNetworkReachabilitySetDispatchQueue		(
						SCNetworkReachabilityRef			target,
						dispatch_queue_t		__nullable	queue
						)				API_AVAILABLE(macos(10.6), ios(4.0));

__END_DECLS

CF_ASSUME_NONNULL_END
CF_IMPLICIT_BRIDGING_DISABLED

#endif	/* _SCNETWORKREACHABILITY_H */
