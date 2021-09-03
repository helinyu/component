//
//  Vertex.h
//  TestVC
//
//  Created by xn on 2021/9/3.
//

#import <Foundation/Foundation.h>
#import "Mark.h"


// 为什么我不可以做一个继承类型的协议呢？ mark这个涉及很多操作的，
// 因为都是一起操作的， 所以是同样的方法
NS_ASSUME_NONNULL_BEGIN

@interface Vertex : NSObject <Mark, NSCopying>

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat size;
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign, readonly) NSUInteger count;// 子节点的个数
@property (nonatomic, assign, readonly) id<Mark> lastChild;

- (id)initWithLocation:(CGPoint)location;
- (void)addMark:(id<Mark>)mark;
- (void)removeMark:(id<Mark>)mark;
- (id<Mark>)childMarkAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
