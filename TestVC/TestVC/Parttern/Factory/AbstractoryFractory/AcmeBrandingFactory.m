//
//  AcmeBrandingFactory.m
//  TestVC
//
//  Created by xn on 2021/9/6.
//

#import "AcmeBrandingFactory.h"
#import "AcmeView.h"
#import "AcmeButton.h"
#import "AcmeToolbar.h"

@implementation AcmeBrandingFactory

- (UIView *)brandedView {
    return [AcmeView new];
}

- (UIButton *)brandedMainButton {
    return [AcmeButton new];
}

- (UIToolbar *)brandedToolbar {
    return [AcmeToolbar new];
}

@end
