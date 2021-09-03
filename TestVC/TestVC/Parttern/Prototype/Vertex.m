//
//  Vertex.m
//  TestVC
//
//  Created by xn on 2021/9/3.
//

#import "Vertex.h"

@implementation Vertex

@dynamic color;
@dynamic size;

- (id)initWithLocation:(CGPoint)location;
{
    self = [super init];
    if (self){
        self.location = location;
    }
    return self;
}
- (void)addMark:(id<Mark>)mark;
{
    
}
- (void)removeMark:(id<Mark>)mark;
{
    
}
- (id<Mark>)childMarkAtIndex:(NSUInteger)index;
{
    return nil;
}

- (UIColor *)color {
    return nil;
}

- (void)setColor:(UIColor *)color {
    
}

- (CGFloat)size {
    return 0.0;
}

- (void)setSize:(CGFloat)size {
    
}

- (id<Mark>)lastChild {
    return nil;
}

- (NSUInteger)count {
    return 0;
}

- (id)copyWithZone:(NSZone *)zone;
{
    return [[[self class] allocWithZone:zone] initWithLocation:self.location];
}

@end
