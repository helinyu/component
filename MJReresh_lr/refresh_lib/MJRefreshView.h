//
//  MJRefreshView.h
//  MJRefreshExample
//
//  Created by xn on 2021/5/27.
//  Copyright © 2021 小码哥. All rights reserved.
//

#import "MJRefreshComponent.h"

NS_ASSUME_NONNULL_BEGIN

// 想写一个包括了所有的刷新的组件

@interface MJRefreshView : MJRefreshComponent


+ (instancetype)refreshViewWithBlock:(MJRefreshComponentAction)refreshingBlock refreshMore:(BOOL)refreshMore refreshBack:(BOOL)refreshBack; // 这个可以考虑使用链式的写法
+ (instancetype)refreshViewWithBlock:(MJRefreshComponentAction)refreshingBlock refreshMore:(BOOL)refreshMore refreshBack:(BOOL)refreshBack horizontalDirection:(BOOL)horizontalDirection;

+ (instancetype)refreshViewWithTarget:(id)target refreshingAction:(SEL)action;

#pragma mark -- MJRefreshAutoFooter
/** 是否自动刷新(默认为YES) */
@property (assign, nonatomic, getter=isAutomaticallyRefresh) BOOL automaticallyRefresh;

/** 当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新) */
@property (assign, nonatomic) CGFloat triggerAutomaticallyRefreshPercent;

/** 自动触发次数, 默认为 1, 仅在拖拽 ScrollView 时才生效,
 
 如果为 -1, 则为无限触发
 */
@property (nonatomic) NSInteger autoTriggerTimes;

#pragma mark - MJRefreshFooter
/** 提示没有更多的数据 */
- (void)endRefreshingWithNoMoreData;
- (void)noticeNoMoreData MJRefreshDeprecated("使用endRefreshingWithNoMoreData");

/** 重置没有更多的数据（消除没有更多数据的状态） */
- (void)resetNoMoreData;

/** 忽略多少scrollView的距离内容最近的变多元 */ 
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetDeta;// 需要增加的deta的内容

#pragma mark -- header的内容

/** 这个key用来存储上一次下拉刷新成功的时间 */
@property (copy, nonatomic) NSString *lastUpdatedTimeKey;
/** 上一次下拉刷新成功的时间 */
@property (strong, nonatomic, readonly, nullable) NSDate *lastUpdatedTime;

/** 默认是关闭状态, 如果遇到 CollectionView 的动画异常问题可以尝试打开 */
@property (nonatomic) BOOL isCollectionViewAnimationBug;

@end

NS_ASSUME_NONNULL_END
