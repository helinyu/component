//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  MJRefreshComponent.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/4.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//  刷新控件的基类

#import <UIKit/UIKit.h>
#import "MJRefreshConst.h"
#import "UIView+MJExtension.h"
#import "UIScrollView+MJExtension.h"
#import "UIScrollView+MJRefresh.h"
#import "NSBundle+MJRefresh.h"

NS_ASSUME_NONNULL_BEGIN

/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger, MJRefreshState) {
    /** 普通闲置状态 */
    MJRefreshStateIdle = 1,
    /** 松开就可以进行刷新的状态 */
    MJRefreshStatePulling,
    /** 正在刷新中的状态 */
    MJRefreshStateRefreshing,
    /** 即将刷新的状态 */
    MJRefreshStateWillRefresh, // 将会刷新，其实算是刷新的一部分， 当时还没有添加到window上的时候
    /** 所有数据加载完毕，没有更多的数据了 */
    MJRefreshStateNoMoreData // 没有数据， 这个应该是怎么进行处理的？
};

/** 刷新用到的回调类型 */
typedef void (^MJRefreshComponentAction)(void);

/** 刷新控件的基类 */
@interface MJRefreshComponent : UIView
{
    /** 记录scrollView刚开始的inset */
    UIEdgeInsets _scrollViewOriginalInset;
    /** 父控件 */
    __weak UIScrollView *_scrollView;
}


#pragma mark -- aisx 都是和坐标轴有感的，也就是方向

//新添加的基本数据
@property (nonatomic, assign) CGFloat asxi_x; // 基础的方向
@property (nonatomic, assign) CGFloat asxi_y; // 伸展的方向
@property (nonatomic, assign) CGFloat asxi_width; // 基础方向长度
@property (nonatomic, assign) CGFloat asxi_height; // 伸展的长度

// scrollView 的内容
@property (nonatomic, assign) CGFloat scroll_asxi_width; // 类似aisxWidth
@property (nonatomic, assign) CGFloat scroll_asix_height; // 类似Asix heigh
@property (nonatomic, assign) CGFloat scroll_asix_offset_y; // offset Y
@property (nonatomic, assign) CGFloat scroll_asix_inset_top;// inset top
@property (nonatomic, assign) CGFloat scroll_asxi_content_width; // 内容的宽度
@property (nonatomic, assign) CGFloat scroll_asxi_content_height; // 内容的宽度

//改变之前的inset的top 和bottom
@property (nonatomic, assign) CGFloat scroll_asix_origin_Inset_top;// inset top
@property (nonatomic, assign) CGFloat scroll_asix_origin_Inset_bottom;// inset bottom

@property (nonatomic, assign) BOOL horizontalDirection;// 水平方向，默认是NO ,NO:垂直方向， YES:水平方向

#pragma mark - 刷新动画时间控制
/** 快速动画时间(一般用在刷新开始的回弹动画), 默认 0.25 */
@property (nonatomic) NSTimeInterval fastAnimationDuration;
/** 慢速动画时间(一般用在刷新结束后的回弹动画), 默认 0.4*/
@property (nonatomic) NSTimeInterval slowAnimationDuration;
/** 关闭全部默认动画效果, 可以简单粗暴地解决 CollectionView 的回弹动画 bug */
- (instancetype)setAnimationDisabled;

#pragma mark - 刷新回调
/** 正在刷新的回调 */
@property (copy, nonatomic, nullable) MJRefreshComponentAction refreshingBlock;
/** 设置回调对象和回调方法 */
- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action;

/** 回调对象 */
@property (weak, nonatomic) id refreshingTarget;
/** 回调方法 */
@property (assign, nonatomic) SEL refreshingAction;
/** 触发回调（交给子类去调用） */
- (void)executeRefreshingCallback;

#pragma mark - 刷新状态控制
/** 进入刷新状态 */
- (void)beginRefreshing;
- (void)beginRefreshingWithCompletionBlock:(void (^)(void))completionBlock;
/** 开始刷新后的回调(进入刷新状态后的回调) */
@property (copy, nonatomic, nullable) MJRefreshComponentAction beginRefreshingCompletionBlock;
/** 带动画的结束刷新的回调 */
@property (copy, nonatomic, nullable) MJRefreshComponentAction endRefreshingAnimateCompletionBlock MJRefreshDeprecated("first deprecated in 3.3.0 - Use `endRefreshingAnimationBeginAction` instead");
@property (copy, nonatomic, nullable) MJRefreshComponentAction endRefreshingAnimationBeginAction;
/** 结束刷新的回调 */
@property (copy, nonatomic, nullable) MJRefreshComponentAction endRefreshingCompletionBlock;
/** 结束刷新状态 */
- (void)endRefreshing;
- (void)endRefreshingWithCompletionBlock:(void (^)(void))completionBlock;
/** 是否正在刷新 */
@property (assign, nonatomic, readonly, getter=isRefreshing) BOOL refreshing;

/** 刷新状态 一般交给子类内部实现 */
@property (assign, nonatomic) MJRefreshState state;

#pragma mark - 交给子类去访问
/** 记录scrollView刚开始的inset */
@property (assign, nonatomic, readonly) UIEdgeInsets scrollViewOriginalInset;
/** 父控件 */
@property (weak, nonatomic, readonly) UIScrollView *scrollView;

#pragma mark - 交给子类们去实现
/** 初始化 */
- (void)prepare NS_REQUIRES_SUPER;
/** 摆放子控件frame */
- (void)placeSubviews NS_REQUIRES_SUPER;
/** 当scrollView的contentOffset发生改变的时候调用 */
- (void)scrollViewContentOffsetDidChange:(nullable NSDictionary *)change NS_REQUIRES_SUPER;
/** 当scrollView的contentSize发生改变的时候调用 */
- (void)scrollViewContentSizeDidChange:(nullable NSDictionary *)change NS_REQUIRES_SUPER;
/** 当scrollView的拖拽状态发生改变的时候调用 */
- (void)scrollViewPanStateDidChange:(nullable NSDictionary *)change NS_REQUIRES_SUPER;


#pragma mark - 其他
/** 拉拽的百分比(交给子类重写) */
@property (assign, nonatomic) CGFloat pullingPercent;
/** 根据拖拽比例自动切换透明度 */
@property (assign, nonatomic, getter=isAutoChangeAlpha) BOOL autoChangeAlpha MJRefreshDeprecated("请使用automaticallyChangeAlpha属性");
/** 根据拖拽比例自动切换透明度 */
@property (assign, nonatomic, getter=isAutomaticallyChangeAlpha) BOOL automaticallyChangeAlpha;
@end

@interface MJRefreshComponent (ChainingGrammar)

#pragma mark - <<< 为 Swift 扩展链式语法 >>> -
/// 自动变化透明度
- (instancetype)autoChangeTransparency:(BOOL)isAutoChange;
/// 刷新开始后立即调用的回调
- (instancetype)afterBeginningAction:(MJRefreshComponentAction)action;
/// 刷新动画开始后立即调用的回调
- (instancetype)endingAnimationBeginningAction:(MJRefreshComponentAction)action;
/// 刷新结束后立即调用的回调
- (instancetype)afterEndingAction:(MJRefreshComponentAction)action;


/// 需要子类必须实现
/// @param scrollView 赋值给的 ScrollView 的 Header/Footer/Trailer
- (instancetype)linkTo:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
