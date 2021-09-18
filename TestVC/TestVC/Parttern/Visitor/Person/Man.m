//
//  Man.m
//  TestVC
//
//  Created by xn on 2021/9/8.
//

#import "Man.h"
#import "Action.h"

@implementation Man

- (void)accept:(id<Action>)visitor {
    [visitor getMainConclusion:self];
}

- (NSString *)name {
    return @"男人";
}

@end
