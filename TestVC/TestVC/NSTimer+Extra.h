//
//  NSTimer+Extra.h
//  TestVC
//
//  Created by xn on 2021/8/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (Extra)

+ (NSTimer *)ex_scheduledTimerWithInterval:(NSTimeInterval)interval block:(void(^)(void))block repeats:(BOOL)repeats;

@end

NS_ASSUME_NONNULL_END
