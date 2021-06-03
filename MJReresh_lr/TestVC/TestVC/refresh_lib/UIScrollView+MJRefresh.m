//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  UIScrollView+MJRefresh.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/4.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "UIScrollView+MJRefresh.h"
#import "MJRefreshView.h"
#import <objc/runtime.h>

@implementation UIScrollView (MJRefresh)

#pragma mark --  有关header 和footer上面的内容

#pragma mark - reset
static const char MJRefreshResetKey = '\0';
- (void)setReset_refreshView:(MJRefreshView *)reset_refreshView {
    if (reset_refreshView != self.reset_refreshView) {
        // 删除旧的，添加新的
        [self.reset_refreshView removeFromSuperview];
        if (reset_refreshView) {
            [self insertSubview:reset_refreshView atIndex:0];
        }
        objc_setAssociatedObject(self, &MJRefreshResetKey,
                                 reset_refreshView, OBJC_ASSOCIATION_RETAIN);
    }
}

- (MJRefreshView *)reset_refreshView {
    return objc_getAssociatedObject(self, &MJRefreshResetKey);
}

#pragma mark -- more
static const char MJRefreshMoreKey = '\0';
- (void)setMore_refreshView:(MJRefreshView *)more_refreshView {
    if (more_refreshView != self.more_refreshView) {
        // 删除旧的，添加新的
        [self.more_refreshView removeFromSuperview];
        if (more_refreshView) {
            [self insertSubview:more_refreshView atIndex:0];
        }
        // 存储新的
        objc_setAssociatedObject(self, &MJRefreshMoreKey,
                                 more_refreshView, OBJC_ASSOCIATION_RETAIN);
    }
}

- (MJRefreshView *)more_refreshView {
    return objc_getAssociatedObject(self, &MJRefreshMoreKey);
}

#pragma mark - other
- (NSInteger)mj_totalDataCount
{
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;

        for (NSInteger section = 0; section < tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;

        for (NSInteger section = 0; section < collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

@end
