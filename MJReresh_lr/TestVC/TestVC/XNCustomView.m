//
//  XNCustomView.m
//  TestVC
//
//  Created by xn on 2021/5/27.
//

#import "XNCustomView.h"

@implementation XNCustomView

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    NSLog(@"willMoveToSuperview :%@",newSuperview);
}

- (void)didMoveToSuperview;
{
    [super didMoveToSuperview];
    
    NSLog(@"didMoveToSuperview");
}

- (void)willMoveToWindow:(nullable UIWindow *)newWindow;
{
    [super willMoveToWindow:newWindow];
    NSLog(@"willMoveToWindow :%@",newWindow);
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    NSLog(@"didMoveToWindow");
}

@end
