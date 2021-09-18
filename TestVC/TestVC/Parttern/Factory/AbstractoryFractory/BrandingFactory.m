//
//  BrandingFactory.m
//  TestVC
//
//  Created by xn on 2021/9/6.
//

#import "BrandingFactory.h"
#import "AcmeBrandingFactory.h"
#import "SierraBrandingFactory.h"

@implementation BrandingFactory

+ (BrandingFactory *)factory {
#if defined (USE_ACME)
    return [AcmeBrandingFactory new];
#elif defined (USE_SIERRA)
    return [SierraBrandingFactory new];
#else
    return nil;
#endif
}

- (UIView *)brandedView {
    return nil;
}

- (UIButton *)brandedMainButton {
    return nil;
}

- (UIToolbar *)brandedToolbar {
    return nil;
}

@end
