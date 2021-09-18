//
//  CanvasViewGenerator.m
//  TestVC
//
//  Created by xn on 2021/9/6.
//

#import "CanvasViewGenerator.h"

@implementation CanvasViewGenerator

+ (CanvasView *)canvasViewWithFrame:(CGRect)aframe;
{
    return [[CanvasView alloc] initWithFrame:aframe];
}

@end
