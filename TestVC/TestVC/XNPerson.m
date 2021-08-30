//
//  XNPerson.m
//  TestVC
//
//  Created by xn on 2021/8/18.
//

#import "XNPerson.h"

@implementation XNPerson

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initTest];
    }
    return self;
}

- (void)initTest {
    
}

- (id)object {
    id obj = [[NSObject alloc] init];
    [obj autorelease];
    return obj;
}

- (id)copyWithZone:(NSZone *)zone {
    XNPerson *cpy = [XNPerson allocWithZone:zone];
    if (cpy) {
        cpy.name = self.name;
        cpy.age = self.age;
    }
    return cpy;
}

@end
