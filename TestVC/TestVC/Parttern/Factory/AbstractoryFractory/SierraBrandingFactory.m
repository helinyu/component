//
//  SierraBrandingFactory.m
//  TestVC
//
//  Created by xn on 2021/9/6.
//

#import "SierraBrandingFactory.h"
#import "SierraView.h"
#import "SierraButton.h"
#import "SierraToolbar.h"

@implementation SierraBrandingFactory

- (UIView *)brandedView {
    return [SierraView new];
}

- (UIButton *)brandedMainButton {
    return [SierraButton new];
}

- (UIToolbar *)brandedToolbar {
    return [SierraToolbar new];
}

@end
