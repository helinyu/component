//
//  Stroke.m
//  TestVC
//
//  Created by xn on 2021/9/3.
//

#import "Stroke.h"

@interface Stroke ()

@property (nonatomic, strong) NSMutableArray<id<Mark>> *children;

@end

@implementation Stroke

@dynamic location;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.children = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}

- (void)setLocation:(CGPoint)location {
    // it doesn't set any arbitrary location
}

- (CGPoint)location {
    if (self.children.count > 0) {
        return [[self.children objectAtIndex:0] location];
    }
    return CGPointZero;
}

- (void)addMark:(id<Mark>)mark {
    [self.children addObject:mark];
}

- (void)removeMark:(id<Mark>)mark {
    // 如果mark在这一层，将其移除并返回
    //    否则，让每个子节点去找到它
    if ([self.children containsObject:mark]) {
        [self.children removeObject:mark];
    }
    else {
        [self.children makeObjectsPerformSelector:@selector(removeMark:) withObject:mark];
    }
}

- (id<Mark>)childMarkAtIndex:(NSUInteger)index {
    if (index >= self.children.count) return nil;
    return [self.children objectAtIndex:index];
}

//返回最后子节点的遍历方法
- (id<Mark>)lastChild {
    return [self.children lastObject];
}

// 返回子节点数
- (NSUInteger)count {
    return self.children.count;
}

- (id)copyWithZone:(NSZone *)zone {
    Stroke *copy = [[[self class] allocWithZone:zone] init];
    copy.color = [UIColor colorWithCGColor:self.color.CGColor];
    copy.size = self.size;
    for (id<Mark> child in self.children) {
        id<Mark> childCopy = [child copy];
        [copy addMark:childCopy];
    }
    return copy;
}

@end
