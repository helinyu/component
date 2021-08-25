/*	CFRunLoop.h
	Copyright (c) 1998-2019, Apple Inc. and the Swift project authors
 
	Portions Copyright (c) 2014-2019, Apple Inc. and the Swift project authors
	Licensed under Apache License v2.0 with Runtime Library Exception
	See http://swift.org/LICENSE.txt for license information
	See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
*/

#if !defined(__COREFOUNDATION_CFRUNLOOP__)
#define __COREFOUNDATION_CFRUNLOOP__ 1

#include <CoreFoundation/CFBase.h>
#include <CoreFoundation/CFArray.h>
#include <CoreFoundation/CFDate.h>
#include <CoreFoundation/CFString.h>
#if TARGET_OS_OSX || TARGET_OS_IPHONE
#include <mach/port.h>
#endif

CF_IMPLICIT_BRIDGING_ENABLED
CF_EXTERN_C_BEGIN

typedef CFStringRef CFRunLoopMode CF_EXTENSIBLE_STRING_ENUM;

// 集中桥接的引用
typedef struct CF_BRIDGED_MUTABLE_TYPE(id) __CFRunLoop * CFRunLoopRef; 
typedef struct CF_BRIDGED_MUTABLE_TYPE(id) __CFRunLoopSource * CFRunLoopSourceRef;
typedef struct CF_BRIDGED_MUTABLE_TYPE(id) __CFRunLoopObserver * CFRunLoopObserverRef;
typedef struct CF_BRIDGED_MUTABLE_TYPE(NSTimer) __CFRunLoopTimer * CFRunLoopTimerRef;


//  CFRunLoopRunInMode() 返回的结果
typedef CF_ENUM(SInt32, CFRunLoopRunResult) {
    kCFRunLoopRunFinished = 1,
    kCFRunLoopRunStopped = 2,
    kCFRunLoopRunTimedOut = 3,
    kCFRunLoopRunHandledSource = 4
};

//  runloop 观察的活动
typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
    kCFRunLoopEntry = (1UL << 0), //进入
    kCFRunLoopBeforeTimers = (1UL << 1), // 定时器
    kCFRunLoopBeforeSources = (1UL << 2), // sources
    kCFRunLoopBeforeWaiting = (1UL << 5), // 等待之前
    kCFRunLoopAfterWaiting = (1UL << 6), // 等待之后
    kCFRunLoopExit = (1UL << 7), // 退出
    kCFRunLoopAllActivities = 0x0FFFFFFFU // 所有活动
};

//  两种常用模式
CF_EXPORT const CFRunLoopMode kCFRunLoopDefaultMode;
CF_EXPORT const CFRunLoopMode kCFRunLoopCommonModes;

//  runloop ID
CF_EXPORT CFTypeID CFRunLoopGetTypeID(void);

//  当前的runloop
CF_EXPORT CFRunLoopRef CFRunLoopGetCurrent(void);

//  主线程的runloop
CF_EXPORT CFRunLoopRef CFRunLoopGetMain(void);

//  当前runloop的mode
CF_EXPORT CFRunLoopMode CFRunLoopCopyCurrentMode(CFRunLoopRef rl);

// 所有mode
CF_EXPORT CFArrayRef CFRunLoopCopyAllModes(CFRunLoopRef rl);

//  添加公共mode
CF_EXPORT void CFRunLoopAddCommonMode(CFRunLoopRef rl, CFRunLoopMode mode);

// 获取下一次定时器的云心时间
CF_EXPORT CFAbsoluteTime CFRunLoopGetNextTimerFireDate(CFRunLoopRef rl, CFRunLoopMode mode);
// 运行
CF_EXPORT void CFRunLoopRun(void);
//  运行模式的结果
CF_EXPORT CFRunLoopRunResult CFRunLoopRunInMode(CFRunLoopMode mode, CFTimeInterval seconds, Boolean returnAfterSourceHandled);
// 等待
CF_EXPORT Boolean CFRunLoopIsWaiting(CFRunLoopRef rl);
//  唤醒
CF_EXPORT void CFRunLoopWakeUp(CFRunLoopRef rl);
//  停止
CF_EXPORT void CFRunLoopStop(CFRunLoopRef rl);

//  执行的block
#if __BLOCKS__
CF_EXPORT void CFRunLoopPerformBlock(CFRunLoopRef rl, CFTypeRef mode, void (^block)(void)) API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); 
#endif

// 包含source
CF_EXPORT Boolean CFRunLoopContainsSource(CFRunLoopRef rl, CFRunLoopSourceRef source, CFRunLoopMode mode);
// 添加source
CF_EXPORT void CFRunLoopAddSource(CFRunLoopRef rl, CFRunLoopSourceRef source, CFRunLoopMode mode);
// 移除source
CF_EXPORT void CFRunLoopRemoveSource(CFRunLoopRef rl, CFRunLoopSourceRef source, CFRunLoopMode mode);

// 包括observer
CF_EXPORT Boolean CFRunLoopContainsObserver(CFRunLoopRef rl, CFRunLoopObserverRef observer, CFRunLoopMode mode);

//  添加observer
CF_EXPORT void CFRunLoopAddObserver(CFRunLoopRef rl, CFRunLoopObserverRef observer, CFRunLoopMode mode);
CF_EXPORT void CFRunLoopRemoveObserver(CFRunLoopRef rl, CFRunLoopObserverRef observer, CFRunLoopMode mode);

// 包括timer
CF_EXPORT Boolean CFRunLoopContainsTimer(CFRunLoopRef rl, CFRunLoopTimerRef timer, CFRunLoopMode mode);
CF_EXPORT void CFRunLoopAddTimer(CFRunLoopRef rl, CFRunLoopTimerRef timer, CFRunLoopMode mode);
CF_EXPORT void CFRunLoopRemoveTimer(CFRunLoopRef rl, CFRunLoopTimerRef timer, CFRunLoopMode mode);

#pragma mark - source 

//  source 包括source0 以及source1

typedef struct {
    CFIndex	version;
    void *	info;
    const void *(*retain)(const void *info);
    void	(*release)(const void *info);
    CFStringRef	(*copyDescription)(const void *info);
    Boolean	(*equal)(const void *info1, const void *info2);
    CFHashCode	(*hash)(const void *info);
    void	(*schedule)(void *info, CFRunLoopRef rl, CFRunLoopMode mode);
    void	(*cancel)(void *info, CFRunLoopRef rl, CFRunLoopMode mode);
    void	(*perform)(void *info);
} CFRunLoopSourceContext;

typedef struct {
    CFIndex	version;
    void *	info;
    const void *(*retain)(const void *info);
    void	(*release)(const void *info);
    CFStringRef	(*copyDescription)(const void *info);
    Boolean	(*equal)(const void *info1, const void *info2);
    CFHashCode	(*hash)(const void *info);
#if TARGET_OS_OSX || TARGET_OS_IPHONE
    mach_port_t	(*getPort)(void *info);
    void *	(*perform)(void *msg, CFIndex size, CFAllocatorRef allocator, void *info);
#else
    void *	(*getPort)(void *info);
    void	(*perform)(void *info);
#endif
} CFRunLoopSourceContext1; // source1 上下文 ， source1 包括里面的NSPort的内容

//  获取source的id
CF_EXPORT CFTypeID CFRunLoopSourceGetTypeID(void);

//  创建一个runloopSource
CF_EXPORT CFRunLoopSourceRef CFRunLoopSourceCreate(CFAllocatorRef allocator, CFIndex order, CFRunLoopSourceContext *context);

CF_EXPORT CFIndex CFRunLoopSourceGetOrder(CFRunLoopSourceRef source); // 序号
CF_EXPORT void CFRunLoopSourceInvalidate(CFRunLoopSourceRef source); // 失效
CF_EXPORT Boolean CFRunLoopSourceIsValid(CFRunLoopSourceRef source); // 有效

//  获取source 的上下文
CF_EXPORT void CFRunLoopSourceGetContext(CFRunLoopSourceRef source, CFRunLoopSourceContext *context);

// signal， 具有触发作用
CF_EXPORT void CFRunLoopSourceSignal(CFRunLoopSourceRef source);

#pragma mark - observer

typedef struct {
    CFIndex	version;
    void *	info;
    const void *(*retain)(const void *info);
    void	(*release)(const void *info);
    CFStringRef	(*copyDescription)(const void *info);
} CFRunLoopObserverContext; // Observer 上下文

//  观察者的回调 （我们外面的观察者是不是这个？ 好像我们经常没有放在主线程，好像不是主线程也可以的）
typedef void (*CFRunLoopObserverCallBack)(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info);

CF_EXPORT CFTypeID CFRunLoopObserverGetTypeID(void);

//  observer 的创建和处理
CF_EXPORT CFRunLoopObserverRef CFRunLoopObserverCreate(CFAllocatorRef allocator, CFOptionFlags activities, Boolean repeats, CFIndex order, CFRunLoopObserverCallBack callout, CFRunLoopObserverContext *context);
#if __BLOCKS__
CF_EXPORT CFRunLoopObserverRef CFRunLoopObserverCreateWithHandler(CFAllocatorRef allocator, CFOptionFlags activities, Boolean repeats, CFIndex order, void (^block) (CFRunLoopObserverRef observer, CFRunLoopActivity activity)) API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0));
#endif

CF_EXPORT CFOptionFlags CFRunLoopObserverGetActivities(CFRunLoopObserverRef observer);
CF_EXPORT Boolean CFRunLoopObserverDoesRepeat(CFRunLoopObserverRef observer);
CF_EXPORT CFIndex CFRunLoopObserverGetOrder(CFRunLoopObserverRef observer);
CF_EXPORT void CFRunLoopObserverInvalidate(CFRunLoopObserverRef observer);
CF_EXPORT Boolean CFRunLoopObserverIsValid(CFRunLoopObserverRef observer);
CF_EXPORT void CFRunLoopObserverGetContext(CFRunLoopObserverRef observer, CFRunLoopObserverContext *context);


#pragma mark - timer

typedef struct {
    CFIndex	version;
    void *	info;
    const void *(*retain)(const void *info);
    void	(*release)(const void *info);
    CFStringRef	(*copyDescription)(const void *info);
} CFRunLoopTimerContext; // timer上下文

typedef void (*CFRunLoopTimerCallBack)(CFRunLoopTimerRef timer, void *info);

CF_EXPORT CFTypeID CFRunLoopTimerGetTypeID(void);

// 创建与执行
CF_EXPORT CFRunLoopTimerRef CFRunLoopTimerCreate(CFAllocatorRef allocator, CFAbsoluteTime fireDate, CFTimeInterval interval, CFOptionFlags flags, CFIndex order, CFRunLoopTimerCallBack callout, CFRunLoopTimerContext *context);
#if __BLOCKS__
CF_EXPORT CFRunLoopTimerRef CFRunLoopTimerCreateWithHandler(CFAllocatorRef allocator, CFAbsoluteTime fireDate, CFTimeInterval interval, CFOptionFlags flags, CFIndex order, void (^block) (CFRunLoopTimerRef timer)) API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0));
#endif

// 有关属性方法
CF_EXPORT CFAbsoluteTime CFRunLoopTimerGetNextFireDate(CFRunLoopTimerRef timer);
CF_EXPORT void CFRunLoopTimerSetNextFireDate(CFRunLoopTimerRef timer, CFAbsoluteTime fireDate);
CF_EXPORT CFTimeInterval CFRunLoopTimerGetInterval(CFRunLoopTimerRef timer);
CF_EXPORT Boolean CFRunLoopTimerDoesRepeat(CFRunLoopTimerRef timer);
CF_EXPORT CFIndex CFRunLoopTimerGetOrder(CFRunLoopTimerRef timer);
CF_EXPORT void CFRunLoopTimerInvalidate(CFRunLoopTimerRef timer);
CF_EXPORT Boolean CFRunLoopTimerIsValid(CFRunLoopTimerRef timer);
CF_EXPORT void CFRunLoopTimerGetContext(CFRunLoopTimerRef timer, CFRunLoopTimerContext *context);

// Setting a tolerance for a timer allows it to fire later than the scheduled fire date, improving the ability of the system to optimize for increased power savings and responsiveness. The timer may fire at any time between its scheduled fire date and the scheduled fire date plus the tolerance. The timer will not fire before the scheduled fire date. For repeating timers, the next fire date is calculated from the original fire date regardless of tolerance applied at individual fire times, to avoid drift. The default value is zero, which means no additional tolerance is applied. The system reserves the right to apply a small amount of tolerance to certain timers regardless of the value of this property.
// As the user of the timer, you will have the best idea of what an appropriate tolerance for a timer may be. A general rule of thumb, though, is to set the tolerance to at least 10% of the interval, for a repeating timer. Even a small amount of tolerance will have a significant positive impact on the power usage of your application. The system may put a maximum value of the tolerance.
//  timer的容忍度
CF_EXPORT CFTimeInterval CFRunLoopTimerGetTolerance(CFRunLoopTimerRef timer) API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0));
CF_EXPORT void CFRunLoopTimerSetTolerance(CFRunLoopTimerRef timer, CFTimeInterval tolerance) API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0));

CF_EXTERN_C_END
CF_IMPLICIT_BRIDGING_DISABLED

#endif /* ! __COREFOUNDATION_CFRUNLOOP__ */

