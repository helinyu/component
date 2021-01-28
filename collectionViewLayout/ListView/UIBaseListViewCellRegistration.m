//
//  UIBaseCollectionViewCellRegistration.m
//  testVC
//
//  Created by xn on 2021/1/28.
//

#import "UIBaseListViewCellRegistration.h"
//#import "UICollectionViewCellRegistration.h"


@interface UIBaseListViewCellRegistration ()

@property (nonatomic, strong) UICollectionViewCellRegistration *registration API_AVAILABLE(ios(14.0));

// 下面是初六iOS14之前的系统
@property(nonatomic,nullable) Class cellClass;
@property(nonatomic, copy) UIListCellRegistrationConfigurationHandler configurationHandler;

@end

@implementation UIBaseListViewCellRegistration

+ (instancetype)registrationWithCellClass:(Class)cellClass configurationHandler:(UIListCellRegistrationConfigurationHandler)configurationHandler {
    UIBaseListViewCellRegistration *baseRegistration = [[UIBaseListViewCellRegistration alloc] init];
    if ([cellClass isKindOfClass:[UICollectionViewCell class]]) {
        if (@available(iOS 14.0, *)) {
            UICollectionViewCellRegistration *registration = [UICollectionViewCellRegistration registrationWithCellClass:cellClass configurationHandler:configurationHandler];
            baseRegistration.registration = registration;
        }
    }
    baseRegistration.cellClass = cellClass;
    baseRegistration.configurationHandler = configurationHandler;
    return baseRegistration;
}

- (Class)cellClass {
    if (@available(iOS 14.0, *)) {
        return self.registration.cellClass;
    }
    else {
        return _cellClass;
    }
}

- (void (^)(id _Nonnull, NSIndexPath * _Nonnull, id _Nonnull))configurationHandler {
    if (@available(iOS 14.0, *)) {
        return self.registration.configurationHandler;
    }
    else {
        return _configurationHandler;
    }
}

@end
