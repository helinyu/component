//
//  UIBaseCollectionView.m
//  testVC
//
//  Created by xn on 2021/1/28.
//

#import "UIBaseCollectionView.h"
#import "UIBaseListViewCellRegistration.h"

@implementation UIBaseCollectionView

- (__kindof UICollectionViewCell *)dequeueConfiguredReusableCellWithRegistration:(UIBaseListViewCellRegistration*)registration forIndexPath:(NSIndexPath*)indexPath item:(id __nullable)item {
    if (@available(iOS 14.0, *)) {
       return [super dequeueConfiguredReusableCellWithRegistration:registration.registration forIndexPath:indexPath item:item];
    }
    else {
        if (!registration.hasRegister) {
            [self registerClass:registration.cellClass forCellWithReuseIdentifier:NSStringFromClass(registration.cellClass)];
            registration.hasRegister = YES;
        }
        
        UICollectionViewCell *cell = [self dequeueReusableCellWithReuseIdentifier:NSStringFromClass(registration.cellClass) forIndexPath:indexPath];
        if (registration.configurationHandler) {
            registration.configurationHandler(cell, indexPath, item);
        }
        return cell;
    }
}

@end
