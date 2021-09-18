/*	NSRunLoop.h
	Copyright (c) 1994-2019, Apple Inc. All rights reserved.
*/

#import <Foundation/NSObject.h>
#import <Foundation/NSDate.h>
#import <CoreFoundation/CFRunLoop.h>// 里面使用了CGRunloop的内容

@class NSTimer, NSPort, NSArray<ObjectType>, NSString;

//  runloop中常见的两种相关的类型

NS_ASSUME_NONNULL_BEGIN

//  两种常用的模式
FOUNDATION_EXPORT NSRunLoopMode const NSDefaultRunLoopMode;
FOUNDATION_EXPORT NSRunLoopMode const NSRunLoopCommonModes API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));

@interface NSRunLoop : NSObject {
@private
    id          _rl;
    id          _dperf;
    id          _perft;
    id          _info;
    id		_ports;
    void	*_reserved[6];
}

@property (class, readonly, strong) NSRunLoop *currentRunLoop; // 当前线程的runloop
@property (class, readonly, strong) NSRunLoop *mainRunLoop API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0)); // 

@property (nullable, readonly, copy) NSRunLoopMode currentMode; // 当前runloop的mode

- (CFRunLoopRef)getCFRunLoop CF_RETURNS_NOT_RETAINED; // cf的方式

- (void)addTimer:(NSTimer *)timer forMode:(NSRunLoopMode)mode; // 给timer添加runloop的模式
//  timer么有移除的模式

- (void)addPort:(NSPort *)aPort forMode:(NSRunLoopMode)mode; // 给port添加runloop的模式
- (void)removePort:(NSPort *)aPort forMode:(NSRunLoopMode)mode; // 给port移除runloop的模式

- (nullable NSDate *)limitDateForMode:(NSRunLoopMode)mode; // 对模式的限制日志
- (void)acceptInputForMode:(NSRunLoopMode)mode beforeDate:(NSDate *)limitDate;// 接入模式在限制日期之前

@end

//  runloop里面涉及到的内容
//  1） timer
//  2） port
//  3） 执行和时间的关系
//  NSRunloop 只是暴露一下简单的内容

//  runloop的一些分类方法
//  1） 执行的遍历
//  2)  延迟执行
//  3)  顺序执行 （用得比较少）
@interface NSRunLoop (NSRunLoopConveniences)

- (void)run;  // 当前就运行
- (void)runUntilDate:(NSDate *)limitDate; // 知道时间的运行
- (BOOL)runMode:(NSRunLoopMode)mode beforeDate:(NSDate *)limitDate; //  运行模式在限制日期之前

//  block里面之心的代码在runloop给定的模式下面
- (void)performInModes:(NSArray<NSRunLoopMode> *)modes block:(void (^)(void))block API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

//  在目标的runloop里面执行block CFRunLoopPerformBlock
- (void)performBlock:(void (^)(void))block API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

@end

/**************** 	Delayed perform	 ******************/

@interface NSObject (NSDelayedPerforming)

//  延迟处理的方法
// 异步方法，不会阻塞当前线程，只能在主线程中执行。是把`Selector`加到主队列里，当 `delay`之后执行`Selector`。如果主线程在执行业务，那只能等到执行完所有业务之后才会去执行`Selector`，就算`delay`等于 0。
// 那`delay `从什么时候开始计算呢？从发送`performSelector`消息的时候。就算这时主线程在阻塞也会计算时间，当阻塞结束之后，如果到了`delay`那就执行`Selector`，如果没到就继续 `delay`。
// 只能在主线程中执行，在子线程中不会调到aSelector方法
- (void)performSelector:(SEL)aSelector withObject:(nullable id)anArgument afterDelay:(NSTimeInterval)delay inModes:(NSArray<NSRunLoopMode> *)modes;
- (void)performSelector:(SEL)aSelector withObject:(nullable id)anArgument afterDelay:(NSTimeInterval)delay;
+ (void)cancelPreviousPerformRequestsWithTarget:(id)aTarget selector:(SEL)aSelector object:(nullable id)anArgument;
+ (void)cancelPreviousPerformRequestsWithTarget:(id)aTarget;

@end

@interface NSRunLoop (NSOrderedPerform)

// 按某种顺序order执行方法。参数order越小，优先级越高，执行越早
// selector都是target的方法，argument都是target的参数
- (void)performSelector:(SEL)aSelector target:(id)target argument:(nullable id)arg order:(NSUInteger)order modes:(NSArray<NSRunLoopMode> *)modes;
- (void)cancelPerformSelector:(SEL)aSelector target:(id)target argument:(nullable id)arg;
- (void)cancelPerformSelectorsWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
