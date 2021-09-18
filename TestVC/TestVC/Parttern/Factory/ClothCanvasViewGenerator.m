//
//  ClothCanvasViewGenerator.m
//  TestVC
//
//  Created by xn on 2021/9/6.
//

#import "ClothCanvasViewGenerator.h"
#import "ClothCanvasView.h"

@implementation ClothCanvasViewGenerator

- (CanvasView *)canvasViewWithFrame:(CGRect)aframe {
    return [[ClothCanvasView alloc] initWithFrame:aframe];
}

@end
