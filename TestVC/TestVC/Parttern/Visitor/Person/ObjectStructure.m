//
//  ObjectStructure.m
//  TestVC
//
//  Created by xn on 2021/9/8.
//

#import "ObjectStructure.h"
#import "Person.h"
#import "Action.h"

@implementation ObjectStructure

- (NSMutableArray *)arr {
    if (!_arr) {
        _arr = [NSMutableArray new];
    }
    return _arr;
}

- (void)display:(id<Action>)visitor {
    for (id<Person> p in _arr) {
        [p accept:visitor];
    }
}

@end
