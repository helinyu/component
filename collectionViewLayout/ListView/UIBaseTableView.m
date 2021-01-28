//
//  UIBaseTableView.m
//  testVC
//
//  Created by xn on 2021/1/28.
//

#import "UIBaseTableView.h"

@implementation UIBaseTableView

- (__kindof UITableViewCell *)dequeueConfiguredReusableCellWithRegistration:(UIBaseListViewCellRegistration*)registration forIndexPath:(NSIndexPath*)indexPath item:(id __nullable)item {
    if (!registration.hasRegister) {
        [self registerClass:registration.cellClass forCellReuseIdentifier:NSStringFromClass(registration.cellClass)];
        registration.hasRegister = YES;
    }
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:NSStringFromClass(registration.cellClass) forIndexPath:indexPath];
    if (registration.configurationHandler) {
        registration.configurationHandler(cell, indexPath, item);
    }
    return cell;
}

@end
