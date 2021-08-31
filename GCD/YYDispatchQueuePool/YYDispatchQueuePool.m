//
//  YYDispatchQueueManager.m
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 15/7/18.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "YYDispatchQueuePool.h"
#import <UIKit/UIKit.h>
#import <libkern/OSAtomic.h>

#define MAX_QUEUE_COUNT 32

#define Dispatch_create_Queue(queueName, context, index, qos)  \
static dispatch_once_t onceToken; \
            dispatch_once(&onceToken, ^{ \
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount; \
                count = count < 1 ? 1 : count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count; \
                context[index] = YYDispatchContextCreate(queueName, count, qos); \
            }); \
            return context[index]; \
            \

// 通过qos获取对饮的队列优先级
static inline dispatch_queue_priority_t NSQualityOfServiceToDispatchPriority(NSQualityOfService qos) {
    switch (qos) {
        case NSQualityOfServiceUserInteractive: return DISPATCH_QUEUE_PRIORITY_HIGH;
        case NSQualityOfServiceUserInitiated: return DISPATCH_QUEUE_PRIORITY_HIGH;
        case NSQualityOfServiceUtility: return DISPATCH_QUEUE_PRIORITY_LOW;
        case NSQualityOfServiceBackground: return DISPATCH_QUEUE_PRIORITY_BACKGROUND;
        case NSQualityOfServiceDefault: return DISPATCH_QUEUE_PRIORITY_DEFAULT;
        default: return DISPATCH_QUEUE_PRIORITY_DEFAULT;
    }
}

// 通过qos 获取对应的质量服务
static inline qos_class_t NSQualityOfServiceToQOSClass(NSQualityOfService qos) {
    switch (qos) {
        case NSQualityOfServiceUserInteractive: return QOS_CLASS_USER_INTERACTIVE; //用户交互
        case NSQualityOfServiceUserInitiated: return QOS_CLASS_USER_INITIATED; // 用户初始化
        case NSQualityOfServiceUtility: return QOS_CLASS_UTILITY; // 统一
        case NSQualityOfServiceBackground: return QOS_CLASS_BACKGROUND; // 后台
        case NSQualityOfServiceDefault: return QOS_CLASS_DEFAULT; // 默认
        default: return QOS_CLASS_UNSPECIFIED; // 默认是没有指定的 【课呢鞥是根据系统的状况来随意处理吧】
    }
}

/*
2、QoS技术
QoS技术是在macOS10.10和iOS8之后的新技术，通过QoS高速操作系统并发队列如何工作，然后操作系统会通过合理的资源控制，从而以最搞笑的方式执行并发队列。这其中主要涉及CPU调度、IO操作优先级、任务执行在哪个线程以及执行的顺序等内容。我们通过抽象的Quality of Service参数来表明任务的意图以及类别。QoS提供NSQualityOfService（swift是QualityOfService）枚举类型，有如下5个成员：
（1）NSQualityOfSErviceUserInteractive，与用户交互的任务，这些任务通常跟UI刷新相关，例如动画，他会在一瞬间完成。
（2）NSQualityOfServiceUserInitiated，由用户发起的并且可以立即得到结果的任务。例如翻动表视图时加载数据，然后显示单元格，这些任务通常跟后续的用户交互相关，会在几秒或者更短的时间内完成。
（3）NSQualityOfServiceUtility，一些耗时的任务，这些任务不会马上返回结果，例如下载任务，它可能花费好几秒或者几分钟的时间。
（4）NSQualityOfServiceBackground，这些任务对用户不可见，可以长时间在后台运行。
（5）NSQualityOfServiceDefault，优先级介于NSQualityOfSErviceUserInteractive和NSQualityOfServiceUtility之间，这个值是系统默认值，我们不应该使用它设置自己的任务。

NSQualityOfServiceUserInteractive：最高优先级, 用于处理 UI 相关的任务
NSQualityOfServiceUserInitiated：次高优先级, 用于执行需要立即返回的任务
NSQualityOfServiceUtility：普通优先级，主要用于不需要立即返回的任务
NSQualityOfServiceBackground：后台优先级，用于处理一些用户不会感知的任务
NSQualityOfServiceDefault：默认优先级，当没有设置优先级的时候，线程默认优先级

typedef NS_ENUM(NSInteger, NSQualityOfService) {
    NSQualityOfServiceUserInteractive = 0x21,
    NSQualityOfServiceUserInitiated = 0x19,
    NSQualityOfServiceUtility = 0x11,
    NSQualityOfServiceBackground = 0x09,
    NSQualityOfServiceDefault = -1
} API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));


// 底部对应的枚举烈性
__QOS_ENUM(qos_class, unsigned int,
	QOS_CLASS_USER_INTERACTIVE
			__QOS_CLASS_AVAILABLE(macos(10.10), ios(8.0)) = 0x21,
	QOS_CLASS_USER_INITIATED
			__QOS_CLASS_AVAILABLE(macos(10.10), ios(8.0)) = 0x19,
	QOS_CLASS_DEFAULT
			__QOS_CLASS_AVAILABLE(macos(10.10), ios(8.0)) = 0x15,
	QOS_CLASS_UTILITY
			__QOS_CLASS_AVAILABLE(macos(10.10), ios(8.0)) = 0x11,
	QOS_CLASS_BACKGROUND
			__QOS_CLASS_AVAILABLE(macos(10.10), ios(8.0)) = 0x09,
	QOS_CLASS_UNSPECIFIED
			__QOS_CLASS_AVAILABLE(macos(10.10), ios(8.0)) = 0x00,
);


*/

typedef struct {
    const char *name; // 名字
    void **queues; // 队列
    uint32_t queueCount; // 队列数目 @[dispatch_queue_t]
    int32_t counter; // 计数器？？
} YYDispatchContext;

//  创建这样的一个队列池对象
static YYDispatchContext *YYDispatchContextCreate(const char *name,
                                                 uint32_t queueCount,
                                                 NSQualityOfService qos) {
    YYDispatchContext *context = calloc(1, sizeof(YYDispatchContext));
    if (!context) return NULL;
    context->queues =  calloc(queueCount, sizeof(void *));
    if (!context->queues) {
        free(context);
        return NULL;
    }
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        dispatch_qos_class_t qosClass = NSQualityOfServiceToQOSClass(qos);
        for (NSUInteger i = 0; i < queueCount; i++) {
            dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, qosClass, 0); // 新的方式， 通过attr来精心这个队列， retain队列
            dispatch_queue_t queue = dispatch_queue_create(name, attr);
            context->queues[i] = (__bridge_retained void *)(queue);
        }
    } else {
        long identifier = NSQualityOfServiceToDispatchPriority(qos); // 获取对应的标识符
        for (NSUInteger i = 0; i < queueCount; i++) {
            //  通过dispatch_set_target_queue设置队列的分类关系 
            dispatch_queue_t queue = dispatch_queue_create(name, DISPATCH_QUEUE_SERIAL); // 创建了串行队列
            dispatch_set_target_queue(queue, dispatch_get_global_queue(identifier, 0)); // 设置大搜全局队列里面，某个标识符
            context->queues[i] = (__bridge_retained void *)(queue);
        }
    }
    context->queueCount = queueCount;
    if (name) {
         context->name = strdup(name);
    }
    return context;
}

static void YYDispatchContextRelease(YYDispatchContext *context) {
    if (!context) return;
    if (context->queues) {
        for (NSUInteger i = 0; i < context->queueCount; i++) {
            void *queuePointer = context->queues[i];
            dispatch_queue_t queue = (__bridge_transfer dispatch_queue_t)(queuePointer);
            const char *name = dispatch_queue_get_label(queue);
            if (name) strlen(name);
            queue = nil;
        }
        free(context->queues);
        context->queues = NULL;
    }
    if (context->name) free((void *)context->name);
    free(context);
}

//  获取当前的context queue？
//  获取当前使用的队列
static dispatch_queue_t YYDispatchContextGetQueue(YYDispatchContext *context) {
    uint32_t counter = (uint32_t)OSAtomicIncrement32(&context->counter);
    void *queue = context->queues[counter % context->queueCount];
    return (__bridge dispatch_queue_t)(queue);
}


//  通过CPU的核数量进行判断这个对垒要实现多少个
//  每一种类型都创建这样的数目
static YYDispatchContext *YYDispatchContextGetForQOS(NSQualityOfService qos) {
    static YYDispatchContext *context[5] = {0};
    // 这里存放的是有关的队列上下文的数组，
    // 每个上下文都有队列对象的数组
    switch (qos) {
        case NSQualityOfServiceUserInteractive: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[0] = YYDispatchContextCreate("com.ibireme.yykit.user-interactive", count, qos);
            });
            return context[0];
        } break;
        case NSQualityOfServiceUserInitiated: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[1] = YYDispatchContextCreate("com.ibireme.yykit.user-initiated", count, qos);
            });
            return context[1];
        } break;
        case NSQualityOfServiceUtility: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[2] = YYDispatchContextCreate("com.ibireme.yykit.utility", count, qos);
            });
            return context[2];
        } break;
        case NSQualityOfServiceBackground: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[3] = YYDispatchContextCreate("com.ibireme.yykit.background", count, qos);
            });
            return context[3];
        } break;
        case NSQualityOfServiceDefault:
        default: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[4] = YYDispatchContextCreate("com.ibireme.yykit.default", count, qos);
            });
            return context[4];
        } break;
    }
}


@implementation YYDispatchQueuePool {
    @public
    YYDispatchContext *_context; // 其实就是使用了里面的这个上下文对象
}

- (void)dealloc {
    if (_context) {
        YYDispatchContextRelease(_context);
        _context = NULL;
    }
}

- (instancetype)initWithContext:(YYDispatchContext *)context {
    self = [super init];
    if (!context) return nil;
    self->_context = context;
    _name = context->name ? [NSString stringWithUTF8String:context->name] : nil;
    return self;
}


- (instancetype)initWithName:(NSString *)name queueCount:(NSUInteger)queueCount qos:(NSQualityOfService)qos {
    if (queueCount == 0 || queueCount > MAX_QUEUE_COUNT) return nil;
    self = [super init];
    _context = YYDispatchContextCreate(name.UTF8String, (uint32_t)queueCount, qos);
    if (!_context) return nil;
    _name = name;
    return self;
}

- (dispatch_queue_t)queue {
    return YYDispatchContextGetQueue(_context);
}

+ (instancetype)defaultPoolForQOS:(NSQualityOfService)qos {
    switch (qos) {
        case NSQualityOfServiceUserInteractive: {
            static YYDispatchQueuePool *pool;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pool = [[YYDispatchQueuePool alloc] initWithContext:YYDispatchContextGetForQOS(qos)];
            });
            return pool;
        } break;
        case NSQualityOfServiceUserInitiated: {
            static YYDispatchQueuePool *pool;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pool = [[YYDispatchQueuePool alloc] initWithContext:YYDispatchContextGetForQOS(qos)];
            });
            return pool;
        } break;
        case NSQualityOfServiceUtility: {
            static YYDispatchQueuePool *pool;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pool = [[YYDispatchQueuePool alloc] initWithContext:YYDispatchContextGetForQOS(qos)];
            });
            return pool;
        } break;
        case NSQualityOfServiceBackground: {
            static YYDispatchQueuePool *pool;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pool = [[YYDispatchQueuePool alloc] initWithContext:YYDispatchContextGetForQOS(qos)];
            });
            return pool;
        } break;
        case NSQualityOfServiceDefault:
        default: {
            static YYDispatchQueuePool *pool;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pool = [[YYDispatchQueuePool alloc] initWithContext:YYDispatchContextGetForQOS(NSQualityOfServiceDefault)];
            });
            return pool;
        } break;
    }
}

@end

// 获取当前qos的单签队列
dispatch_queue_t YYDispatchQueueGetForQOS(NSQualityOfService qos) {
    return YYDispatchContextGetQueue(YYDispatchContextGetForQOS(qos));
}
