//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  UIScrollView+MJRefresh.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/4.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//  给ScrollView增加下拉刷新、上拉刷新、 左滑刷新的功能

#import <UIKit/UIKit.h>
#import "MJRefreshConst.h"

@class MJRefreshHeader, MJRefreshFooter, MJRefreshTrailer, MJRefreshView;

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (MJRefresh)

// 重置刷新
@property (strong, nonatomic, nullable) MJRefreshView *reset_refreshView; // 这个是刷新页面

// 加载更多刷新
@property (strong, nonatomic, nullable) MJRefreshView *more_refreshView; // 这个是加载更多的页面

#pragma mark - other
- (NSInteger)mj_totalDataCount;

@end

NS_ASSUME_NONNULL_END
