//
//  UIBaseCollectionViewCellRegistration.h
//  testVC
//
//  Created by xn on 2021/1/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 包括collectionView 和tableView
typedef void(^UIListCellRegistrationConfigurationHandler)(id _Nonnull cell, NSIndexPath * _Nonnull indexPath, id _Nonnull item);

@interface UIBaseListViewCellRegistration : NSObject

@property (nonatomic, strong, readonly) UICollectionViewCellRegistration *registration API_AVAILABLE(ios(14.0)); // 特殊的collectionView的 iOS 14

+ (instancetype)registrationWithCellClass:(Class)cellClass configurationHandler:(UIListCellRegistrationConfigurationHandler)configurationHandler;
@property(nonatomic,readonly) Class cellClass;
@property(nonatomic,readonly) UIListCellRegistrationConfigurationHandler configurationHandler;
@property (nonatomic, assign) BOOL hasRegister;

@end

NS_ASSUME_NONNULL_END
