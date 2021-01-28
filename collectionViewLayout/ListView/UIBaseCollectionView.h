//
//  UIBaseCollectionView.h
//  testVC
//
//  Created by xn on 2021/1/28.
//

#import <UIKit/UIKit.h>
#import "UIBaseListViewCellRegistration.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIBaseCollectionView : UICollectionView

- (__kindof UICollectionViewCell *)dequeueConfiguredReusableCellWithRegistration:(UIBaseListViewCellRegistration*)registration forIndexPath:(NSIndexPath*)indexPath item:(id __nullable)item;

@end

NS_ASSUME_NONNULL_END
