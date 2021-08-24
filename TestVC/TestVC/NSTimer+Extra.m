//
//  NSTimer+Extra.m
//  TestVC
//
//  Created by xn on 2021/8/24.
//

#import "NSTimer+Extra.h"

@implementation NSTimer (Extra)


+ (NSTimer *)ex_scheduledTimerWithInterval:(NSTimeInterval)interval block:(void(^)(void))block repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(ex_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)ex_blockInvoke:(NSTimer *)timer {
    void(^block)(void) = timer.userInfo;
    !block? :block();
}

@end
