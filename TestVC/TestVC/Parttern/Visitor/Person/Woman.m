//
//  Woman.m
//  TestVC
//
//  Created by xn on 2021/9/8.
//

#import "Woman.h"
#import "Action.h"
#import "Person.h"

@implementation Woman

- (void)accept:(id<Action>)visitor {
    [visitor getWomanConclusion:self];
}

- (NSString *)name {
    return @"女人";
}

@end
