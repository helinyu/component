//
//  BrandingFactory.h
//  TestVC
//
//  Created by xn on 2021/9/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BrandingFactory : NSObject

+ (BrandingFactory *)factory;
- (UIView *)brandedView;
- (UIButton *)brandedMainButton;
- (UIToolbar *)brandedToolbar;

@end

NS_ASSUME_NONNULL_END
