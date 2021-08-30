//
//  UIImage+Transform.m
//  Decorator
//
//  Created by Carlo Chung on 11/15/10.
//  Copyright 2010 Carlo Chung. All rights reserved.
//

#import "UIImage+Transform.h"
#import "UIImage+BaseFilter.h"

@implementation UIImage (Transform)

- (UIImage *) imageWithTransform:(CGAffineTransform)transform
{
  CGContextRef context = [self beginContext];
  
  // setup transformation
  CGContextConcatCTM(context, transform); // 这里设置的了内容， 我到底是使用了子类化还是使用装饰模式？
  
  // Draw the original image to the context
  UIImage *imageOut = [self getImageFromCurrentImageContext];
  
  [self endContext];
  
  return imageOut;
}

@end
