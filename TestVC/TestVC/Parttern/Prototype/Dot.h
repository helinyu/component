//
//  Dot.h
//  TestVC
//
//  Created by xn on 2021/9/3.
//

#import "Vertex.h"

NS_ASSUME_NONNULL_BEGIN

@interface Dot : Vertex

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat size;

@end

NS_ASSUME_NONNULL_END
