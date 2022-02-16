//
//  NSObject+Add.m
//  KCObjcBuild
//
//  Created by xn on 2022/2/15.
//

#import "NSObject+Add.h"
#import <objc/runtime.h>

@implementation NSObject (Add)

@end

@implementation NSObject (a)

//@property (nonatomic, copy) NSString *name;
- (NSString *)name {
    return objc_getAssociatedObject(self, "name.key");
}

- (void)setName:(NSString *)name {
    objc_setAssociatedObject(self, "name.key", name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)aaaa;
{
    NSLog(@"lt - aaaa");
}

@end
