//
//  MarkVisitor.h
//  TestVC
//
//  Created by xn on 2021/9/8.
//

#import <Foundation/Foundation.h>

@protocol Mark;
@class Dot,Vertex, Stroke;

NS_ASSUME_NONNULL_BEGIN

@protocol MarkVisitor <NSObject>

- (void)visitMark:(id<Mark>)mark;
- (void)visitDot:(Dot *)dot;
- (void)visitVertex:(Vertex *)vertex;
- (void)visitStroke:(Stroke *)stroke;

@end

NS_ASSUME_NONNULL_END
