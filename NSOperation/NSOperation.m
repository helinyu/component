//  如何重写这个类的内容

#import <Foundation/NSObject.h>
#import <Foundation/NSException.h>
#import <Foundation/NSProgress.h>
#import <sys/qos.h>
#import <dispatch/dispatch.h>

@class NSArray<ObjectType>, NSSet;

NS_ASSUME_NONNULL_BEGIN

//  我们常常用来设置有关的优先级的内容， 看看这些内容有些什么东西？
#define NSOperationQualityOfService NSQualityOfService
#define NSOperationQualityOfServiceUserInteractive NSQualityOfServiceUserInteractive
#define NSOperationQualityOfServiceUserInitiated NSQualityOfServiceUserInitiated
#define NSOperationQualityOfServiceUtility NSQualityOfServiceUtility
#define NSOperationQualityOfServiceBackground NSQualityOfServiceBackground

//  这个其实就是其中类型的内容

API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0))
@interface NSOperation : NSObject
//  这个胡歌内部舒心暂时不用管
#if !__OBJC2__
{
@private
    id _private;
    int32_t _private1;
#if __LP64__
    int32_t _private1b;
#endif
}
#endif

- (void)start; // 开始
- (void)main; // 主线程？

@property (readonly, getter=isCancelled) BOOL cancelled;
- (void)cancel; // 取消

@property (readonly, getter=isExecuting) BOOL executing; // 执行中
@property (readonly, getter=isFinished) BOOL finished; // 完成
@property (readonly, getter=isConcurrent) BOOL concurrent; // To be deprecated; use and override 'asynchronous' below
@property (readonly, getter=isAsynchronous) BOOL asynchronous API_AVAILABLE(macos(10.8), ios(7.0), watchos(2.0), tvos(9.0));
//  是否是并行？ 现在并行没有判断了， 这里只是判断了异步， 有没有并行就不知道了，如果是在同步队列中。。。
@property (readonly, getter=isReady) BOOL ready; // 准备

- (void)addDependency:(NSOperation *)op; // 设置operation的依赖
- (void)removeDependency:(NSOperation *)op; // 移除依赖

@property (readonly, copy) NSArray<NSOperation *> *dependencies; // 有关的依赖

//  操作的优先等级
typedef NS_ENUM(NSInteger, NSOperationQueuePriority) {
	NSOperationQueuePriorityVeryLow = -8L,
	NSOperationQueuePriorityLow = -4L,
	NSOperationQueuePriorityNormal = 0,
	NSOperationQueuePriorityHigh = 4,
	NSOperationQueuePriorityVeryHigh = 8
};


//  上面重新定义的宏定义的额优先级 ， 这些优先级的内容
// 其实这个优先级也是有数字的关系的， 中间的数字应该也是可以的
@property NSOperationQueuePriority queuePriority;

//  为什么有一个完成的回调？ （这里只是一个优先级）
@property (nullable, copy) void (^completionBlock)(void) API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));

//  等待直到完成
- (void)waitUntilFinished API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));

//  这个暂时先不管， 好像我们现在这个封装，直接就没有线程的概念暴露出来了
@property double threadPriority API_DEPRECATED("Not supported", macos(10.6,10.10), ios(4.0,8.0), watchos(2.0,2.0), tvos(9.0,9.0));

//  优先级
@property NSQualityOfService qualityOfService API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));

// 优先级的名字
@property (nullable, copy) NSString *name API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));

@end


//  block 的operation 进行对基本的额operation进行了重写， 这个有设么不一样的地方？
API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0))
@interface NSBlockOperation : NSOperation
#if !__OBJC2__
{
@private
    id _private2;
    void *_reserved2;
}
#endif

//  通过block的方式进行了添加任务
+ (instancetype)blockOperationWithBlock:(void (^)(void))block;

- (void)addExecutionBlock:(void (^)(void))block;
@property (readonly, copy) NSArray<void (^)(void)> *executionBlocks;

@end

// swift 是一个静态编译的语言， 这要去看看
API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0))
NS_SWIFT_UNAVAILABLE("NSInvocation and related APIs not available")
@interface NSInvocationOperation : NSOperation
#if !__OBJC2__
{
@private
    id _inv;
    id _exception;
    void *_reserved2;
}
#endif

- (nullable instancetype)initWithTarget:(id)target selector:(SEL)sel object:(nullable id)arg;
- (instancetype)initWithInvocation:(NSInvocation *)inv NS_DESIGNATED_INITIALIZER;

@property (readonly, retain) NSInvocation *invocation;

@property (nullable, readonly, retain) id result;

@end

// 不管是block还是invocation，这个都是执行的一种封装的方式

//  为什么要有这样的一个通知？
FOUNDATION_EXPORT NSExceptionName const NSInvocationOperationVoidResultException API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));
FOUNDATION_EXPORT NSExceptionName const NSInvocationOperationCancelledException API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));

//  默认是没有的
static const NSInteger NSOperationQueueDefaultMaxConcurrentOperationCount = -1;


```
// NSProgress 上面的内容   这个以后看看要怎么去使用
@protocol NSProgressReporting <NSObject>
@property (readonly) NSProgress *progress;
@end

```


API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0))
@interface NSOperationQueue : NSObject <NSProgressReporting>
#if !__OBJC2__
{
@private
    id _private;
    void *_reserved;
}
#endif

//  属性： 进度
//  progress ：表示在执行队列中的全部的进度， 默认是NSOperationQueue
// 直到totalUnitCount 设置了进度滞后，才会上报这个进度， 当设置了之后，对了选择去上报指定的进度。
//   启用时，对于在main结束时完成的操作，每个操作将为队列的总体进度贡献1个完成单位（覆盖start但是不调用super的操作将不会贡献进度）。
//  全部单元数目totalUnitCount
//  指定尝试控制速度，当更新totalUnitCount 的进度， 应该拒绝回溯进度（应该就是不能够从50% -> 49%）
//  例如： 当一个NSOperationQueue 的进度是5/10 ，表示是50% 完成， 然后90多个添加到totalUnitCount中， 进度变成了5/100 ，表示5% ，将不会被描述。
// 在这些例子中， totalUnitCount 需要被调整， 需要在线程暗转中处理， 通过栅栏addBarrierBlock 接口， 这样确保没有不期望的异常状态发生在一个潜在的进度回溯中 
/// @example
/// NSOperationQueue *queue = [[NSOperationQueue alloc] init];
/// queue.progress.totalUnitCount = 10;

//  这个东西是如何进行控制的， 看看有哪些变化的内容了
@property (readonly, strong) NSProgress *progress API_AVAILABLE(macos(10.15), ios(13.0), tvos(13.0), watchos(6.0));
//  上面是有关进度的解释， 看看这个解释是什么意思？

//  queue 可以直接添加一个operation， 可以添加多个operation， 可以直接添加block进行调试
- (void)addOperation:(NSOperation *)op;
- (void)addOperations:(NSArray<NSOperation *> *)ops waitUntilFinished:(BOOL)wait API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));
- (void)addOperationWithBlock:(void (^)(void))block API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));

/// @method addBarrierBlock:
/// @param barrier      A block to execute
/// @discussion         The `addBarrierBlock:` method executes the block when the NSOperationQueue has finished all enqueued operations and
/// prevents any subsequent operations to be executed until the barrier has been completed. This acts similarly to the
/// `dispatch_barrier_async` function.
//  iOS 13 之后，有这个操作？ 添加了栅栏的内容
- (void)addBarrierBlock:(void (^)(void))barrier API_AVAILABLE(macos(10.15), ios(13.0), tvos(13.0), watchos(6.0));

@property NSInteger maxConcurrentOperationCount; // 最大的并行的操作数量

@property (getter=isSuspended) BOOL suspended; // 先挂，就是暂停，为啥不是pause

@property (nullable, copy) NSString *name API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // 名字

@property NSQualityOfService qualityOfService API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0)); // 服务的质量

@property (nullable, assign /* actually retain */) dispatch_queue_t underlyingQueue API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0)); // 添加到gcd执行的队列里面

- (void)cancelAllOperations; // 取消所有的操作

- (void)waitUntilAllOperationsAreFinished; // 停止，直到所有的操作完成， 默认应该是这样的吧？

//  类属性， 看看这个内容是什么， 类对象的属性
@property (class, readonly, strong, nullable) NSOperationQueue *currentQueue API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // 当前的队列
@property (class, readonly, strong) NSOperationQueue *mainQueue API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // 主队列

@end

//  这个这哪是不用了， operation的操作，这个要怎么处理？
// addBarrierBlock 这个有栅栏的操作的内容
@interface NSOperationQueue (NSDeprecated)

// These two functions are inherently a race condition and should be avoided if possible

@property (readonly, copy) NSArray<__kindof NSOperation *> *operations API_DEPRECATED("access to operations is inherently a race condition, it should not be used. For barrier style behaviors please use addBarrierBlock: instead", macos(10.5, API_TO_BE_DEPRECATED), ios(2.0, API_TO_BE_DEPRECATED), watchos(2.0, API_TO_BE_DEPRECATED), tvos(9.0, API_TO_BE_DEPRECATED));

//  progress的内容有判断
@property (readonly) NSUInteger operationCount API_DEPRECATED_WITH_REPLACEMENT("progress.completedUnitCount", macos(10.6, API_TO_BE_DEPRECATED), ios(4.0, API_TO_BE_DEPRECATED), watchos(2.0, API_TO_BE_DEPRECATED), tvos(9.0, API_TO_BE_DEPRECATED));

@end

NS_ASSUME_NONNULL_END

比较简单的使用， 看看和GCD的内容，如何进行更加细致的区分； 看看我们的需求里面是如何进行使用的； 
AFNetworking 以及SDWebImage 是如何进行使用的； 



有关nsoperation的使用情况，