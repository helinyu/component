//
//  Dot.m
//  TestVC
//
//  Created by xn on 2021/9/3.
//

#import "Dot.h"

@implementation Dot

@synthesize color;
@synthesize size;

- (id)copyWithZone:(NSZone *)zone {
    Dot *copy = [Dot new];
    copy = [copy initWithLocation:self.location];
//     复制颜色, 相当于重新创建一个颜色对象
    [copy setColor:[UIColor colorWithCGColor:[self.color CGColor]]];
    
    copy.size = self.size;
    return copy;
}

@end
