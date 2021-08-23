//
//  XNLockModel.m
//  TestVC
//
//  Created by xn on 2021/8/23.
//

#import "XNLockModel.h"
#import "XNPerson.h"
#import <libkern/OSAtomic.h>
#import <pthread.h>


@implementation XNLockModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initBase0];
    }
    return self;
}

- (void)initBase0 {
    XNPerson *person = [XNPerson new];
    @synchronized (person) {
        
    }
}

- (void)initBase1 {
    OSSpinLock *lock = OS_SPINLOCK_INIT;
    OSSpinLockLock(lock);
    XNPerson *person1 = [XNPerson new];
    OSSpinLockUnlock(lock);
}

- (void)initBase2 {
    dispatch_semaphore_t sem = dispatch_semaphore_create(1);
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    XNPerson *person = [XNPerson new];
    dispatch_semaphore_signal(sem);
}

- (void)initBase3 {
    pthread_mutex_t lock;
    pthread_mutex_init(&lock, NULL);
    pthread_mutex_lock(&lock);
    XNPerson *p = [XNPerson new];
    pthread_mutex_unlock(&lock);
    
}

- (void)initBase4 {
    NSLock *lock = [NSLock new];
    [lock lock];
    XNPerson *p = [XNPerson new];
    [lock unlock];
    
}

- (void)initBase5 {
    NSCondition *condtion = [NSCondition new];
    [condtion lock];
    [condtion unlock];
}


- (void)initBase6 {
    
     {
         pthread_mutex_t lock;
         pthread_mutexattr_t attr;
         pthread_mutexattr_init(&attr);
         pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
         pthread_mutex_init(&lock, &attr);
         pthread_mutexattr_destroy(&attr);
//         begin = CACurrentMediaTime();
//         for (int i = 0; i < count; i++) {
             pthread_mutex_lock(&lock);
             pthread_mutex_unlock(&lock);
//         }
//         end = CACurrentMediaTime();
//         TimeCosts[LockTypepthread_mutex_recursive] += end - begin;
         pthread_mutex_destroy(&lock);
//         printf("pthread_mutex(recursive): %8.2f ms\n", (end - begin) * 1000);
     }
}

- (void)initBase7 {
    
    
    {
        NSRecursiveLock *lock = [NSRecursiveLock new];
//        begin = CACurrentMediaTime();
//        for (int i = 0; i < count; i++) {
            [lock lock];
            [lock unlock];
//        }
//        end = CACurrentMediaTime();
//        TimeCosts[LockTypeNSRecursiveLock] += end - begin;
//        printf("NSRecursiveLock:          %8.2f ms\n", (end - begin) * 1000);
    }
    
}

- (void)initBae8 {
    NSConditionLock *lock = [[NSConditionLock alloc] initWithCondition:1];
    [lock lock];
    [lock unlock];
}


@end
