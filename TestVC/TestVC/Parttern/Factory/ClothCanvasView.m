//
//  ClothCanvasView.m
//  TestVC
//
//  Created by xn on 2021/9/6.
//

#import "ClothCanvasView.h"
// 将有布质风格的背景

@interface ClothCanvasView ()



@end

@implementation ClothCanvasView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *backgroundImage = [UIImage imageNamed:@"cloth"];
        UIImageView *backgroudView = [[UIImageView alloc] initWithImage:backgroundImage];
        [self addSubview:backgroudView];
    }
    return self;
}

@end
