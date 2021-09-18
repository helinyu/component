//
//  PaperCanvasViewGenerator.m
//  TestVC
//
//  Created by xn on 2021/9/6.
//

#import "PaperCanvasViewGenerator.h"
#import "PaperCanvasView.h"

@implementation PaperCanvasViewGenerator

- (CanvasView *)canvasViewWithFrame:(CGRect)aframe {
    return [[PaperCanvasView alloc] initWithFrame:aframe];
}

@end
