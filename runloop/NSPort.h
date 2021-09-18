// NSPort 用于线程和进程之间的交互。 

/*
为了让mach向后兼容， +allocWithZone:发送到NSPort类时候返回NSMachPort类的实例。  否则， 它将会返回一个具体子类，该子类可用于本地机器上的线程或进程之间的消息传递。 
*/
// NSPort 无效的通知
FOUNDATION_EXPORT NSNotificationName const NSPortDidBecomeInvalidNotification; 

#pragra mark -- 有关NSPort里面的接口详解
# NSPort 在iOS中更加像是一个基类
@interface NSPort : NSObject <NSCopying, NSCoding>

+ (NSPort *)port; // 默认方法

 // 使其无效 、 是否有效
- (void)invalidate;
@property (readonly, getter=isValid) BOOL valid;

//  设置有关的代理
- (void)setDelegate:(nullable id <NSPortDelegate>)anObject;
- (nullable id <NSPortDelegate>)delegate;

// (1) 就是给端口添加监听
// (2)子类需要实现这个方法
// (3) 不应该直接调用
// 这两个方法应该通过子类实现，添加到runloop设置端口监听
// 从runloop中删除停止端口监听。
// 这两个不方法 不应该直接调用。
- (void)scheduleInRunLoop:(NSRunLoop *)runLoop forMode:(NSRunLoopMode)mode;
- (void)removeFromRunLoop:(NSRunLoop *)runLoop forMode:(NSRunLoopMode)mode;


// 传输API， 子类必须实现这些方法
@property (readonly) NSUInteger reservedSpaceLength;    // 保留空间长度，默认是0

- (BOOL)sendBeforeDate:(NSDate *)limitDate components:(nullable NSMutableArray *)components from:(nullable NSPort *) receivePort reserved:(NSUInteger)headerSpaceReserved;
- (BOOL)sendBeforeDate:(NSDate *)limitDate msgid:(NSUInteger)msgID components:(nullable NSMutableArray *)components from:(nullable NSPort *)receivePort reserved:(NSUInteger)headerSpaceReserved;
// component 由于NSData子类的一系列实例和NSPort的子类实例组成的。
//因为NSPort的一个子类不一定知道如何传输NSPort子类实例（或者及其知道另一个子类也可以这样做），因为，components中的所有NSPort实例和“receivePort”参数必须与接收次消息的NSPort的子类相同。如果在同一个程序中使用多个传输API， 需要注意。 【也就是发送的NSPort和接收的NSPort的对象类是一样的【子类一样】】

// OSX 和 OS_MACCATALYST 才有的接口，推荐使用NSXPCConnection
//
#if TARGET_OS_OSX || TARGET_OS_MACCATALYST
- (void)addConnection:(NSConnection *)conn toRunLoop:(NSRunLoop *)runLoop forMode:(NSRunLoopMode)mode NS_SWIFT_UNAVAILABLE("Use NSXPCConnection instead") API_DEPRECATED("Use NSXPCConnection instead", macosx(10.0, 10.13), ios(2.0,11.0), watchos(2.0,4.0), tvos(9.0,11.0));
- (void)removeConnection:(NSConnection *)conn fromRunLoop:(NSRunLoop *)runLoop forMode:(NSRunLoopMode)mode NS_SWIFT_UNAVAILABLE("Use NSXPCConnection instead") API_DEPRECATED("Use NSXPCConnection instead", macosx(10.0, 10.13), ios(2.0,11.0), watchos(2.0,4.0), tvos(9.0,11.0));
// 默认实现这两个方法去简单添加接收端口在指定的mode上运行runloop。 子类不需要重写这些方法，除非需要额外的工作。【也就是重写要调用super 】

// MACCATALYST 参考连接 ， 只要是见ipad app转化为mac app
//https://blog.csdn.net/CrazyApp/article/details/109224506
//https://www.sohu.com/a/445339514_208051
#endif

@end


// NSPort的代理方法
@protocol NSPortDelegate <NSObject>
@optional
- (void)handlePortMessage:(NSPortMessage *)message;
// 子类必须发送这个代理方法，除非子类又更多具体的东西要先发送。
这是子类应该发送给它们的委托的委托方法，除非子类有更具体的东西要先发送
@end

#if TARGET_OS_OSX || TARGET_OS_IPHONE

NS_AUTOMATED_REFCOUNT_WEAK_UNAVAILABLE 
@interface NSMachPort : NSPort {
    @private
    id _delegate;
    NSUInteger _flags;
    uint32_t _machPort;
    NSUInteger _reserved;
}

// 初始化方法
+ (NSPort *)portWithMachPort:(uint32_t)machPort;
- (instancetype)initWithMachPort:(uint32_t)machPort NS_DESIGNATED_INITIALIZER;

- (void)setDelegate:(nullable id <NSMachPortDelegate>)anObject;
- (nullable id <NSMachPortDelegate>)delegate;

// 接收和发送到数据之后是否立即销毁
typedef NS_OPTIONS(NSUInteger, NSMachPortOptions) {
    NSMachPortDeallocateNone = 0,
    NSMachPortDeallocateSendRight = (1UL << 0),
    NSMachPortDeallocateReceiveRight = (1UL << 1) 
} API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));

+ (NSPort *)portWithMachPort:(uint32_t)machPort options:(NSMachPortOptions)f API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));
- (instancetype)initWithMachPort:(uint32_t)machPort options:(NSMachPortOptions)f API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0)) NS_DESIGNATED_INITIALIZER;

@property (readonly) uint32_t machPort; // 端口数字

- (void)scheduleInRunLoop:(NSRunLoop *)runLoop forMode:(NSRunLoopMode)mode;
- (void)removeFromRunLoop:(NSRunLoop *)runLoop forMode:(NSRunLoopMode)mode;

@end

@protocol NSMachPortDelegate <NSPortDelegate>
@optional
//代理调用这个方法，否则调用原始的handlePortMessage 代理方法
- (void)handleMachMessage:(void *)msg;

@end

#endif

// NSPortMessage 和 NSMessagePort 应该是同一个东西
// 用于本地信息发送在所有的平台上
NS_AUTOMATED_REFCOUNT_WEAK_UNAVAILABLE 
@interface NSMessagePort : NSPort {
    @private
    void *_port;
    id _delegate;
}
@end


@interface NSSocketPort : NSPort {
    @private
    void *_receiver; // 接收器
    id _connectors; // 连接器
    void *_loops; // loop循环
    void *_data; // 数据
    id _signature; // 签名
    id _delegate; // 代理
    id _lock; // 锁
    NSUInteger _maxSize;// 最大数目
    NSUInteger _useCount; // 使用数目
    NSUInteger _reserved; // 保留字段
}

- (instancetype)init;
- (nullable instancetype)initWithTCPPort:(unsigned short)port; // 通过端口初始化
- (nullable instancetype)initWithProtocolFamily:(int)family socketType:(int)type protocol:(int)protocol address:(NSData *)address NS_DESIGNATED_INITIALIZER; 
// 通过协议族、地址进行初始化
- (nullable instancetype)initWithProtocolFamily:(int)family socketType:(int)type protocol:(int)protocol socket:(NSSocketNativeHandle)sock NS_DESIGNATED_INITIALIZER;
// 协议socket初始化
- (nullable instancetype)initRemoteWithTCPPort:(unsigned short)port host:(nullable NSString *)hostName;
// 端口和主机名字
- (instancetype)initRemoteWithProtocolFamily:(int)family socketType:(int)type protocol:(int)protocol address:(NSData *)address NS_DESIGNATED_INITIALIZER;
// 协议和地址

@property (readonly) int protocolFamily; // 协议族
@property (readonly) int socketType; // 套接字类型
@property (readonly) int protocol; // 协议
@property (readonly, copy) NSData *address;// 地址数据
@property (readonly) NSSocketNativeHandle socket; //套接字 【句柄】

@end



