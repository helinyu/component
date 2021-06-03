//
//  XNCustomTwoView.m
//  TestVC
//
//  Created by xn on 2021/5/27.
//

#import "XNCustomTwoView.h"

@implementation XNCustomTwoView

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    NSLog(@"lt - second willMoveToSuperview :%@",newSuperview);
}

- (void)didMoveToSuperview;
{
    [super didMoveToSuperview];
    
    NSLog(@"lt - second didMoveToSuperview");
}

- (void)willMoveToWindow:(nullable UIWindow *)newWindow;
{
    [super willMoveToWindow:newWindow];
    NSLog(@"lt - second willMoveToWindow :%@",newWindow);
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    NSLog(@"lt - second didMoveToWindow");
}

@end
