//
//  XNStudent.m
//  TestVC
//
//  Created by xn on 2021/9/2.
//

#import "XNStudent.h"

@implementation XNStudent

- (id)copyWithZone:(NSZone *)zone {
    XNStudent *cpy = [[self class] allocWithZone:zone];
    if (cpy) {
        cpy.name = self.name;
    }
    return cpy;
}


@end
