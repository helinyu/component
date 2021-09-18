//
//  Success.m
//  TestVC
//
//  Created by xn on 2021/9/8.
//

#import "Success.h"
#import "Person.h"

@implementation Success

- (void)getMainConclusion:(id<Person>)man {
    NSLog(@"%@%@时候，背后多半有一个伟大的女人",man.name, self.name);
}

- (void)getWomanConclusion:(id<Person>)woman {
    NSLog(@"%@%@时候，背后多半有一个不成功的男人",woman.name, self.name);
}

- (NSString *)name {
    return @"成功";
}

@end
