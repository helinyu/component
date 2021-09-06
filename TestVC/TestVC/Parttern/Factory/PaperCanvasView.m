//
//  PaperCanvasView.m
//  TestVC
//
//  Created by xn on 2021/9/6.
//

#import "PaperCanvasView.h"
//  有再生纸风格的背景

@interface PaperCanvasView ()

@end

@implementation PaperCanvasView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *backgroundImage = [UIImage imageNamed:@"paper"];
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
        [self addSubview:backgroundView];
    }
    return self;
}

@end
