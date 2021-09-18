//
//  CanvasViewGenerator.h
//  TestVC
//
//  Created by xn on 2021/9/6.
//

#import <Foundation/Foundation.h>
#import "CanvasView.h"

NS_ASSUME_NONNULL_BEGIN

// 抽象类中定义的工厂方法
@interface CanvasViewGenerator : NSObject

- (CanvasView *)canvasViewWithFrame:(CGRect)aframe;

@end

NS_ASSUME_NONNULL_END
