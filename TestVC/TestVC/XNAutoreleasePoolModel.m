//
//  XNAutoreleasePoolModel.m
//  TestVC
//
//  Created by xn on 2021/8/30.
//

#import "XNAutoreleasePoolModel.h"
#import "XNPerson.h"

@implementation XNAutoreleasePoolModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initTestAuto];
    }
    return self;
}

- (void)initTestAuto {
    NSMutableArray *s = [NSMutableArray array];
    @autoreleasepool {
        XNPerson *p = [XNPerson new];
        [s addObject:s];
        @autoreleasepool {
            NSLog(@"1");
        }
        
        @autoreleasepool {
            NSLog(@"2");
        }
    }
    
}

@end
