//
//  MJRefreshView.m
//  MJRefreshExample
//
//  Created by xn on 2021/5/27.
//  Copyright © 2021 小码哥. All rights reserved.
//

#import "MJRefreshView.h"

const CGFloat MJRefreshResetDefaultDeta = 54.0;
const CGFloat MJRefreshMoreDefaultDeta = 44.0;

NSString * const MJRefreshResetRefreshing2IdleBoundsKey = @"MJRefreshResetRefreshing2IdleBounds";
NSString * const MJRefreshResetRefreshingBoundsKey = @"MJRefreshResetRefreshingBounds";

@interface MJRefreshView () <CAAnimationDelegate>

@property (nonatomic, assign) BOOL refreshBack; //  相当于footer里面的back ，default: NO , auto: no,  back: YES
@property (nonatomic, assign) BOOL refreshMore; // 判断是刷新的还是加载更多，区分header还是footer ， YES: footer, NO: Header 默认是NO

#pragma mark -- MJRefreshAutoFooter
/** 一个新的拖拽 */
@property (nonatomic) BOOL triggerByDrag;
@property (nonatomic) NSInteger leftTriggerTimes;

#pragma mark - MJRefreshBackFooter

@property (assign, nonatomic) NSInteger lastRefreshCount;
@property (assign, nonatomic) CGFloat lastBottomDelta;

#pragma mark -- header
@property (assign, nonatomic) CGFloat insetTDelta;

@end

@implementation MJRefreshView

+ (instancetype)refreshViewWithBlock:(MJRefreshComponentAction)refreshingBlock refreshMore:(BOOL)refreshMore refreshBack:(BOOL)refreshBack
{
    return [self refreshViewWithBlock:refreshingBlock refreshMore:refreshMore refreshBack:refreshBack horizontalDirection:NO];
}

+ (instancetype)refreshViewWithBlock:(MJRefreshComponentAction)refreshingBlock refreshMore:(BOOL)refreshMore refreshBack:(BOOL)refreshBack horizontalDirection:(BOOL)horizontalDirection {
     MJRefreshView *refreshView = [self new];
    refreshView.refreshingBlock = refreshingBlock;
    refreshView.refreshMore = refreshMore;
    refreshView.refreshBack = refreshBack;
    refreshView.horizontalDirection = horizontalDirection;
    [refreshView configPrepare];
    return refreshView;
}

+ (instancetype)refreshViewWithTarget:(id)target refreshingAction:(SEL)action
{
    MJRefreshView *refreshView = [self new];
    refreshView.refreshingTarget = target;
    refreshView.refreshingAction = action;
    return refreshView;
}

- (void)setRefreshMore:(BOOL)refreshMore {
    _refreshMore = refreshMore;
}
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (self.refreshMore) { // 加载更多的尾部
        if (self.refreshBack) {
            [self configViewY];
        }
        else {
            if (newSuperview) { // 新的父控件
                if (self.hidden == NO) {
                    self.scroll_asix_origin_Inset_bottom += self.asxi_height;
                }
                [self configViewY];
            } else {
                if (self.hidden == NO) {
                    self.scroll_asix_origin_Inset_bottom -= self.asxi_height;
                }
            }
        }
    }
    else { // 刷新， 左边、右边
//        self.mj_wh = [self mj_refreshDefaultDeta];
//         do nothing
    }
}

- (CGFloat)mj_refreshDefaultDeta {
    return self.refreshMore?MJRefreshResetDefaultDeta :MJRefreshMoreDefaultDeta;
}

- (void)configPrepare {
    self.asxi_height = [self mj_refreshDefaultDeta];
    if (self.refreshMore) {
        if (!self.refreshBack) {
            self.triggerAutomaticallyRefreshPercent = 1.0;
            self.automaticallyRefresh = YES;
            self.autoTriggerTimes = 1;
        }

    }
    else {
        // 设置key
        self.lastUpdatedTimeKey = MJRefreshHeaderLastUpdatedTimeKey;
    }
    
}

- (void)prepare
{
    [super prepare];
    
}

- (void)placeSubviews {
    [super placeSubviews];
    
    if (!self.refreshMore) {
        self.asxi_y = - self.asxi_height - self.ignoredScrollViewContentInsetDeta;
    }
}

- (void)resetInset {
    if (@available(iOS 11.0, *)) {
    } else {
        // 如果 iOS 10 及以下系统在刷新时, push 新的 VC, 等待刷新完成后回来, 会导致顶部 Insets.top 异常, 不能 resetInset, 检查一下这种特殊情况
        if (!self.window) { return; }
    }
    
    // sectionheader停留解决 ， 这里需要去适配不同的防线搞得内容
    CGFloat insetT = - self.scroll_asix_offset_y > self.scroll_asix_origin_Inset_top? - self.scroll_asix_offset_y : self.scroll_asix_origin_Inset_top;
    insetT = insetT > self.asxi_height + self.scroll_asix_origin_Inset_top? self.asxi_height + self.scroll_asix_origin_Inset_top: insetT;
    self.insetTDelta = self.scroll_asix_origin_Inset_top - insetT;
    // 避免 CollectionView 在使用根据 Autolayout 和 内容自动伸缩 Cell, 刷新时导致的 Layout 异常渲染问题
    if (self.scroll_asix_inset_top != insetT) {
        self.scroll_asix_inset_top = insetT;
    }
}


- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
    [self configViewY];
}

- (void)configViewY {
    if (self.refreshMore) {// footer 的内容
        CGFloat viewK = self.scroll_asxi_content_height + self.ignoredScrollViewContentInsetDeta;
        if (self.refreshBack) {
            CGFloat scrollLength = self.scroll_asxi_content_height - self.scroll_asix_origin_Inset_top - self.scroll_asix_origin_Inset_bottom + self.ignoredScrollViewContentInsetDeta;
            viewK = MAX(viewK, scrollLength);
        }
        
        self.asxi_y = viewK;
    }
    else { // reset 刷新的内容
        
    }
   
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.refreshMore) {
        if (self.refreshBack) {
            // 如果正在刷新，直接返回
            if (self.state == MJRefreshStateRefreshing) return;
            
            _scrollViewOriginalInset = self.scrollView.mj_inset;
            
            // 当前的contentOffset
            CGFloat currentOffsetY = self.scroll_asix_offset_y;
            // 尾部控件刚好出现的offsetY
            CGFloat happenOffsetY = [self happenOffsetY];
            // 如果是向下滚动到看不见尾部控件，直接返回
            if (currentOffsetY <= happenOffsetY) return;
            
            CGFloat pullingPercent = (currentOffsetY - happenOffsetY) / self.asxi_height;
            
            // 如果已全部加载，仅设置pullingPercent，然后返回
            if (self.state == MJRefreshStateNoMoreData) {
                self.pullingPercent = pullingPercent;
                return;
            }
            
            if (self.scrollView.isDragging) {
                self.pullingPercent = pullingPercent;
                // 普通 和 即将刷新 的临界点
                CGFloat normal2pullingOffsetY = happenOffsetY + self.asxi_height;
                
                if (self.state == MJRefreshStateIdle && currentOffsetY > normal2pullingOffsetY) {
                    // 转为即将刷新状态
                    self.state = MJRefreshStatePulling;
                } else if (self.state == MJRefreshStatePulling && currentOffsetY <= normal2pullingOffsetY) {
                    // 转为普通状态
                    self.state = MJRefreshStateIdle;
                }
            } else if (self.state == MJRefreshStatePulling) {// 即将刷新 && 手松开
                // 开始刷新
                [self beginRefreshing];
            } else if (pullingPercent < 1) {
                self.pullingPercent = pullingPercent;
            }
        }
        else {
            if (self.state != MJRefreshStateIdle || !self.automaticallyRefresh || self.mj_y == 0) return;

            if (self.scroll_asix_inset_top + self.scroll_asxi_content_height > self.asxi_height) { // 内容超过一个屏幕
                // 这里的_scrollView.mj_contentH替换掉self.mj_y更为合理
                if (self.scroll_asix_offset_y >= self.scroll_asxi_content_height - self.asxi_height + self.asxi_height *self.triggerAutomaticallyRefreshPercent + self.scroll_asix_origin_Inset_bottom - self.asxi_height) {
                    // 防止手松开时连续调用
                    CGPoint old = [change[@"old"] CGPointValue];
                    CGPoint new = [change[@"new"] CGPointValue];
                    if (self.horizontalDirection) {
                        if (new.x <= old.x) return;
                    }
                    else {
                        if (new.y <= old.y) return;
                    }

                    if (_scrollView.isDragging) {
                        self.triggerByDrag = YES;
                    }
                    // 当底部刷新控件完全出现时，才刷新
                    [self beginRefreshing];
                }
            }
        }
    }
    else {
        // 在刷新的refreshing状态
        if (self.state == MJRefreshStateRefreshing) {
            [self resetInset];
            return;
        }
        
        // 跳转到下一个控制器时，contentInset可能会变
        _scrollViewOriginalInset = self.scrollView.mj_inset;
        
        // 当前的contentOffset
        CGFloat offsetY = self.scrollView.mj_offsetY;
        // 头部控件刚好出现的offsetY
        CGFloat happenOffsetY = -self.scroll_asix_origin_Inset_top;
        
        // 如果是向上滚动到看不见头部控件，直接返回
        // >= -> >
        if (offsetY > happenOffsetY) return;
        
        // 普通 和 即将刷新 的临界点
        CGFloat normal2pullingOffsetY = happenOffsetY - self.asxi_height;
        CGFloat pullingPercent = (happenOffsetY - offsetY) / self.asxi_height;
        
        if (self.scrollView.isDragging) { // 如果正在拖拽
            self.pullingPercent = pullingPercent;
            if (self.state == MJRefreshStateIdle && offsetY < normal2pullingOffsetY) {
                // 转为即将刷新状态
                self.state = MJRefreshStatePulling;
            } else if (self.state == MJRefreshStatePulling && offsetY >= normal2pullingOffsetY) {
                // 转为普通状态
                self.state = MJRefreshStateIdle;
            }
        } else if (self.state == MJRefreshStatePulling) {// 即将刷新 && 手松开
            // 开始刷新
            [self beginRefreshing];
        } else if (pullingPercent < 1) {
            self.pullingPercent = pullingPercent;
        }
    }
    
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
    if (!(self.refreshMore && !self.refreshBack)) {
        return;
    }
    
    if (self.state != MJRefreshStateIdle) return;
    
    UIGestureRecognizerState panState = _scrollView.panGestureRecognizer.state;
    switch (panState) {
        // 手松开
        case UIGestureRecognizerStateEnded: {
            if (self.scroll_asix_inset_top + self.scroll_asxi_content_height < self.scroll_asix_height) {
                if (self.scroll_asix_offset_y >= - self.scroll_asix_inset_top) {
                    self.triggerByDrag = YES;
                    [self beginRefreshing];
                }
            }
            else {
                if (self.scroll_asix_offset_y >= self.scroll_asxi_content_height + self.scroll_asix_inset_top - self.scroll_asix_height) {
                    self.triggerByDrag = YES;
                    [self beginRefreshing];
                }
            }
        }
            break;
            
        case UIGestureRecognizerStateBegan: {
            [self resetTriggerTimes];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)unlimitedTrigger {
    return self.leftTriggerTimes == -1;
}

- (void)beginRefreshing
{
    if (self.triggerByDrag && self.leftTriggerTimes <= 0 && !self.unlimitedTrigger) {
        return;
    }
    
    [super beginRefreshing];
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    if (self.refreshMore) {
        if (self.refreshBack) {
            // 根据状态来设置属性
            if (state == MJRefreshStateNoMoreData || state == MJRefreshStateIdle) {
                // 刷新完毕
                if (MJRefreshStateRefreshing == oldState) {
                    [UIView animateWithDuration:self.slowAnimationDuration animations:^{
                        if (self.endRefreshingAnimationBeginAction) {
                            self.endRefreshingAnimationBeginAction();
                        }
                        
                        self.scrollView.mj_insetB -= self.lastBottomDelta;
                        // 自动调整透明度
                        if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
                    } completion:^(BOOL finished) {
                        self.pullingPercent = 0.0;
                        
                        if (self.endRefreshingCompletionBlock) {
                            self.endRefreshingCompletionBlock();
                        }
                    }];
                }
                
                CGFloat deltaH = [self heightForContentBreakView];
                // 刚刷新完毕
                if (MJRefreshStateRefreshing == oldState && deltaH > 0 && self.scrollView.mj_totalDataCount != self.lastRefreshCount) {
                    self.scroll_asix_offset_y = self.scroll_asix_offset_y;
                }
            } else if (state == MJRefreshStateRefreshing) {
                // 记录刷新前的数量
                self.lastRefreshCount = self.scrollView.mj_totalDataCount;
                
                [UIView animateWithDuration:self.fastAnimationDuration animations:^{
                    CGFloat bottom = self.mj_h + self.scrollViewOriginalInset.bottom;
                    CGFloat deltaH = [self heightForContentBreakView];
                    if (deltaH < 0) { // 如果内容高度小于view的高度
                        bottom -= deltaH;
                    }
                    self.lastBottomDelta = bottom - self.scrollView.mj_insetB;
                    self.scrollView.mj_insetB = bottom;
                    self.scrollView.mj_offsetY = [self happenOffsetY] + self.mj_h;
                } completion:^(BOOL finished) {
                    [self executeRefreshingCallback];
                }];
            }
        }
        else {
            if (state == MJRefreshStateRefreshing) {
                [self executeRefreshingCallback];
            } else if (state == MJRefreshStateNoMoreData || state == MJRefreshStateIdle) {
                if (self.triggerByDrag) {
                    if (!self.unlimitedTrigger) {
                        self.leftTriggerTimes -= 1;
                    }
                    self.triggerByDrag = NO;
                }
                
                if (MJRefreshStateRefreshing == oldState) {
                    if (self.scrollView.pagingEnabled) {
                        CGPoint offset = self.scrollView.contentOffset;
                        offset.y -= self.scrollView.mj_insetB;
                        [UIView animateWithDuration:self.slowAnimationDuration animations:^{
                            self.scrollView.contentOffset = offset;
                            
                            if (self.endRefreshingAnimationBeginAction) {
                                self.endRefreshingAnimationBeginAction();
                            }
                        } completion:^(BOOL finished) {
                            if (self.endRefreshingCompletionBlock) {
                                self.endRefreshingCompletionBlock();
                            }
                        }];
                        return;
                    }
                    
                    if (self.endRefreshingCompletionBlock) {
                        self.endRefreshingCompletionBlock();
                    }
                }
            }
        }
    }
    else {
        // 根据状态做事情
        if (state == MJRefreshStateIdle) {
            if (oldState != MJRefreshStateRefreshing) return;
            
            [self headerEndingAction];
        } else if (state == MJRefreshStateRefreshing) {
            [self headerRefreshingAction];
        }
    }
    
}

#pragma mark -- header

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *identity = [anim valueForKey:@"identity"];
    if ([identity isEqualToString:MJRefreshResetRefreshing2IdleBoundsKey]) {
        self.pullingPercent = 0.0;
        self.scrollView.userInteractionEnabled = YES;
        if (self.endRefreshingCompletionBlock) {
            self.endRefreshingCompletionBlock();
        }
    } else if ([identity isEqualToString:MJRefreshResetRefreshingBoundsKey]) {
        // 避免出现 end 先于 Refreshing 状态
        if (self.state != MJRefreshStateIdle) {
            CGFloat top = self.scrollViewOriginalInset.top + self.mj_h;
            self.scrollView.mj_insetT = top;
            // 设置最终滚动位置
            CGPoint offset = self.scrollView.contentOffset;
            offset.y = -top;
            [self.scrollView setContentOffset:offset animated:NO];
         }
        self.scrollView.userInteractionEnabled = YES;
        [self executeRefreshingCallback];
    }
    
    if ([self.scrollView.layer animationForKey:MJRefreshResetRefreshing2IdleBoundsKey]) {
        [self.scrollView.layer removeAnimationForKey:MJRefreshResetRefreshing2IdleBoundsKey];
    }
    
    if ([self.scrollView.layer animationForKey:MJRefreshResetRefreshingBoundsKey]) {
        [self.scrollView.layer removeAnimationForKey:MJRefreshResetRefreshingBoundsKey];
    }
}

- (void)headerEndingAction {
    // 保存刷新时间
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.lastUpdatedTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 默认使用 UIViewAnimation 动画
    if (!self.isCollectionViewAnimationBug) {
        // 恢复inset和offset
        [UIView animateWithDuration:self.slowAnimationDuration animations:^{
            self.scroll_asix_inset_top += self.insetTDelta;
            
            if (self.endRefreshingAnimationBeginAction) {
                self.endRefreshingAnimationBeginAction();
            }
            // 自动调整透明度
            if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.pullingPercent = 0.0;
            
            if (self.endRefreshingCompletionBlock) {
                self.endRefreshingCompletionBlock();
            }
        }];
        
        return;
    }
    
    /**
     这个解决方法的思路出自 https://github.com/CoderMJLee/MJRefresh/pull/844
     修改了用+ [UIView animateWithDuration: animations:]实现的修改contentInset的动画
     fix issue#225 https://github.com/CoderMJLee/MJRefresh/issues/225
     另一种解法 pull#737 https://github.com/CoderMJLee/MJRefresh/pull/737
     
     同时, 处理了 Refreshing 中的动画替换.
    */
    
    // 由于修改 Inset 会导致 self.pullingPercent 联动设置 self.alpha, 故提前获取 alpha 值, 后续用于还原 alpha 动画
    CGFloat viewAlpha = self.alpha;
    
    self.scroll_asix_inset_top += self.insetTDelta;
    // 禁用交互, 如果不禁用可能会引起渲染问题.
    self.scrollView.userInteractionEnabled = NO;

    //CAAnimation keyPath 不支持 contentInset 用Bounds的动画代替
    CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    boundsAnimation.fromValue = [NSValue valueWithCGRect:CGRectOffset(self.scrollView.bounds, 0, self.insetTDelta)];
    boundsAnimation.duration = self.slowAnimationDuration;
    //在delegate里移除
    boundsAnimation.removedOnCompletion = NO;
    boundsAnimation.fillMode = kCAFillModeBoth;
    boundsAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    boundsAnimation.delegate = self;
    [boundsAnimation setValue:MJRefreshResetRefreshing2IdleBoundsKey forKey:@"identity"];

    [self.scrollView.layer addAnimation:boundsAnimation forKey:MJRefreshResetRefreshing2IdleBoundsKey];
    
    if (self.endRefreshingAnimationBeginAction) {
        self.endRefreshingAnimationBeginAction();
    }
    // 自动调整透明度的动画
    if (self.isAutomaticallyChangeAlpha) {
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.fromValue = @(viewAlpha);
        opacityAnimation.toValue = @(0.0);
        opacityAnimation.duration = self.slowAnimationDuration;
        opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.layer addAnimation:opacityAnimation forKey:@"MJRefreshResetRefreshing2IdleOpacity"];

        // 由于修改了 inset 导致, pullingPercent 被设置值, alpha 已经被提前修改为 0 了. 所以这里不用置 0, 但为了代码的严谨性, 不依赖其他的特殊实现方式, 这里还是置 0.
        self.alpha = 0;
    }
}

- (void)headerRefreshingAction {
    // 默认使用 UIViewAnimation 动画
    if (!self.isCollectionViewAnimationBug) {
        MJRefreshDispatchAsyncOnMainQueue({
            [UIView animateWithDuration:self.fastAnimationDuration animations:^{
                if (self.scrollView.panGestureRecognizer.state != UIGestureRecognizerStateCancelled) {
                    CGFloat top = self.scroll_asix_origin_Inset_top + self.asxi_height;
                    self.scroll_asix_origin_Inset_top = top;
                    // 设置滚动位置
//                    CGPoint offset = self.scrollView.contentOffset;
//                    [self.scrollView setContentOffset:offset animated:NO];
                    self.scroll_asix_offset_y = -top;
                }
            } completion:^(BOOL finished) {
                [self executeRefreshingCallback];
            }];
        })
        return;
    }
    
    if (self.scrollView.panGestureRecognizer.state != UIGestureRecognizerStateCancelled) {

        CGFloat top = self.scroll_asix_origin_Inset_top + self.asxi_height;
        
        // 禁用交互, 如果不禁用可能会引起渲染问题.
        self.scrollView.userInteractionEnabled = NO;

        // CAAnimation keyPath不支持 contentOffset 用Bounds的动画代替
        CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        CGRect bounds = self.scrollView.bounds;
        bounds.origin.y = -top;
        boundsAnimation.fromValue = [NSValue valueWithCGRect:self.scrollView.bounds];
        boundsAnimation.toValue = [NSValue valueWithCGRect:bounds];
        boundsAnimation.duration = self.fastAnimationDuration;
        //在delegate里移除
        boundsAnimation.removedOnCompletion = NO;
        boundsAnimation.fillMode = kCAFillModeBoth;
        boundsAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        boundsAnimation.delegate = self;
        [boundsAnimation setValue:MJRefreshResetRefreshingBoundsKey forKey:@"identity"];
        [self.scrollView.layer addAnimation:boundsAnimation forKey:MJRefreshResetRefreshingBoundsKey];
    } else {
        [self executeRefreshingCallback];
    }
}

#pragma mark - 公共方法
- (NSDate *)lastUpdatedTime
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:self.lastUpdatedTimeKey];
}

- (void)setIgnoredScrollViewContentInsetDeta:(CGFloat)ignoredScrollViewContentInsetDeta {
    _ignoredScrollViewContentInsetDeta = ignoredScrollViewContentInsetDeta;
    self.asxi_x = - self.asxi_height - self.ignoredScrollViewContentInsetDeta;
}

#pragma mark -- footer back
#pragma mark - 私有方法
#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)heightForContentBreakView
{
    CGFloat h = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
    return self.scrollView.contentSize.height - h;
}

#pragma mark 刚好看到上拉刷新控件时的contentOffset.y
- (CGFloat)happenOffsetY
{
    CGFloat deltaH = [self heightForContentBreakView];
    if (deltaH > 0) {
        return deltaH - self.scrollViewOriginalInset.top;
    } else {
        return - self.scrollViewOriginalInset.top;
    }
}

#pragma mark --


- (void)resetTriggerTimes {
    self.leftTriggerTimes = self.autoTriggerTimes;
}

- (void)setHidden:(BOOL)hidden
{
    BOOL lastHidden = self.isHidden;
    
    [super setHidden:hidden];
    
    if (!lastHidden && hidden) {
        self.state = MJRefreshStateIdle;
        
        self.scrollView.mj_insetB -= self.mj_h;
    } else if (lastHidden && !hidden) {
        self.scrollView.mj_insetB += self.mj_h;
        
        // 设置位置
        self.mj_y = _scrollView.mj_contentH;
    }
}

- (void)setAutoTriggerTimes:(NSInteger)autoTriggerTimes {
    _autoTriggerTimes = autoTriggerTimes;
    self.leftTriggerTimes = autoTriggerTimes;
}

#pragma mark . 链式语法部分 .

- (instancetype)linkTo:(UIScrollView *)scrollView {
    self.refreshMore? (scrollView.more_refreshView = self):(scrollView.reset_refreshView = self);
    return self;
}


@end
