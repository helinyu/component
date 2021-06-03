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
@property (nonatomic, assign) BOOL horizontalDirection;// 水平方向，默认是NO ,NO:垂直方向， YES:水平方向

#pragma mark -- MJRefreshAutoFooter
/** 一个新的拖拽 */
@property (nonatomic) BOOL triggerByDrag;
@property (nonatomic) NSInteger leftTriggerTimes;

#pragma mark - MJRefreshBackFooter

@property (assign, nonatomic) NSInteger lastRefreshCount;
@property (assign, nonatomic) CGFloat lastBottomDelta;

@property (nonatomic, assign) CGFloat offsetK;//x,y中的一个
@property (nonatomic, assign) CGFloat mj_xy;// k 是x，y 中的一个
@property (nonatomic, assign) CGFloat mj_wh; // 宽高中的其中一个
@property (nonatomic, assign) CGFloat scrollContent_mj_xy; // k 是x，y 中的一个
@property (nonatomic, assign) CGFloat scroll_mj_xy; // k 是x，y 中的一个
@property (nonatomic, assign) CGFloat scrollOriginInsetHeader; // 靠近内容的那一部分
@property (nonatomic, assign) CGFloat scrollOriginInsetTail; // 远离内容的那一部分

#pragma mark -- header
@property (assign, nonatomic) CGFloat insetTDelta;

@end

@implementation MJRefreshView

+ (instancetype)refreshViewWithBlock:(MJRefreshComponentAction)refreshingBlock refreshMore:(BOOL)refreshMore
{
    MJRefreshView *refreshView = [self new];
    refreshView.refreshingBlock = refreshingBlock;
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

- (void)setHorizontalDirection:(BOOL)horizontalDirection {
    _horizontalDirection = horizontalDirection;
}


- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (self.refreshMore) { // 加载更多的尾部
        if (self.refreshBack) {
            [self configViewK];
        }
        else {
            if (newSuperview) { // 新的父控件
                if (self.hidden == NO) {
                    self.scrollView.mj_insetB += self.mj_h;
                }
                [self configViewK];
            } else {
                if (self.hidden == NO) {
                    self.scrollView.mj_insetB -= self.mj_h;
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

- (void)prepare
{
    [super prepare];
    
    if (self.refreshMore) {
        //     footer 的内容
            // 默认底部控件100%出现时才会自动刷新
            self.triggerAutomaticallyRefreshPercent = 1.0;
            
            // 设置为默认状态
            self.automaticallyRefresh = YES;
            
            self.autoTriggerTimes = 1;
    }
    else {
        // 设置key
        self.lastUpdatedTimeKey = MJRefreshHeaderLastUpdatedTimeKey;
        self.mj_wh = [self mj_refreshDefaultDeta];
    }
}

- (void)placeSubviews {
    [super placeSubviews];
    
    if (!self.refreshMore) {
        self.mj_xy = - self.mj_wh - self.ignoredScrollViewContentInsetDeta;
    }
}

- (void)resetInset {
    if (@available(iOS 11.0, *)) {
    } else {
        // 如果 iOS 10 及以下系统在刷新时, push 新的 VC, 等待刷新完成后回来, 会导致顶部 Insets.top 异常, 不能 resetInset, 检查一下这种特殊情况
        if (!self.window) { return; }
    }
    
    // sectionheader停留解决 ， 这里需要去适配不同的防线搞得内容
    CGFloat insetT = - self.scrollView.mj_offsetY > _scrollOriginInsetHeader ? - self.scrollView.mj_offsetY : _scrollOriginInsetHeader;
    insetT = insetT > self.mj_wh + _scrollViewOriginalInset.top ? self.mj_h + _scrollViewOriginalInset.top : insetT;
    self.insetTDelta = _scrollViewOriginalInset.top - insetT;
    // 避免 CollectionView 在使用根据 Autolayout 和 内容自动伸缩 Cell, 刷新时导致的 Layout 异常渲染问题
    if (self.scrollView.mj_insetT != insetT) {
        self.scrollView.mj_insetT = insetT;
    }
}


- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
    [self configViewK];
}

- (void)configViewK {
    if (self.refreshMore) {// footer 的内容
        CGFloat viewK = self.scrollContent_mj_xy + self.ignoredScrollViewContentInsetDeta;
        if (self.refreshBack) {
            CGFloat scrollLength = self.scroll_mj_xy - self.scrollOriginInsetHeader - self.scrollOriginInsetTail + self.ignoredScrollViewContentInsetDeta;
            viewK = MAX(viewK, scrollLength);
        }
        
        self.mj_xy = viewK;
    }
    else { // reset 刷新的内容
        
    }
   
}


// 开进内容的那部分
- (CGFloat)scrollOriginInsetHeader {
    return self.horizontalDirection? self.scrollViewOriginalInset.left : self.scrollViewOriginalInset.top;
}

- (CGFloat)scrollOriginInsetTail {
    return self.horizontalDirection? self.scrollViewOriginalInset.right : self.scrollViewOriginalInset.bottom;
}

- (CGFloat)scrollContent_mj_xy {
    return self.horizontalDirection? self.scrollView.mj_contentW : self.scrollView.mj_contentH;
}

- (CGFloat)scroll_mj_xy {
    return self.horizontalDirection? self.scrollView.mj_x:self.mj_y;
}

- (CGFloat)mj_xy {
    return self.horizontalDirection? self.mj_x : self.mj_y;
}

- (void)setMj_xy:(CGFloat)mj_xy {
    self.horizontalDirection? (self.mj_x = mj_xy) : (self.mj_y = mj_xy);
}

- (CGFloat)mj_wh {
    return self.horizontalDirection?self.mj_w:self.mj_h;
}

- (void)setMj_wh:(CGFloat)mj_wh {
    self.horizontalDirection? (self.mj_w = mj_wh) :(self.mj_h = mj_wh);
}


- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.refreshMore) {
        if (self.refreshBack) {
            // 如果正在刷新，直接返回
            if (self.state == MJRefreshStateRefreshing) return;
            
            _scrollViewOriginalInset = self.scrollView.mj_inset;
            
            // 当前的contentOffset
            CGFloat currentOffsetY = self.scrollView.mj_offsetY;
            // 尾部控件刚好出现的offsetY
            CGFloat happenOffsetY = [self happenOffsetY];
            // 如果是向下滚动到看不见尾部控件，直接返回
            if (currentOffsetY <= happenOffsetY) return;
            
            CGFloat pullingPercent = (currentOffsetY - happenOffsetY) / self.mj_h;
            
            // 如果已全部加载，仅设置pullingPercent，然后返回
            if (self.state == MJRefreshStateNoMoreData) {
                self.pullingPercent = pullingPercent;
                return;
            }
            
            if (self.scrollView.isDragging) {
                self.pullingPercent = pullingPercent;
                // 普通 和 即将刷新 的临界点
                CGFloat normal2pullingOffsetY = happenOffsetY + self.mj_h;
                
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

            if (_scrollView.mj_insetT + _scrollView.mj_contentH > _scrollView.mj_h) { // 内容超过一个屏幕
                // 这里的_scrollView.mj_contentH替换掉self.mj_y更为合理
                if (_scrollView.mj_offsetY >= _scrollView.mj_contentH - _scrollView.mj_h + self.mj_h * self.triggerAutomaticallyRefreshPercent + _scrollView.mj_insetB - self.mj_h) {
                    // 防止手松开时连续调用
                    CGPoint old = [change[@"old"] CGPointValue];
                    CGPoint new = [change[@"new"] CGPointValue];
                    if (new.y <= old.y) return;

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
        CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
        
        // 如果是向上滚动到看不见头部控件，直接返回
        // >= -> >
        if (offsetY > happenOffsetY) return;
        
        // 普通 和 即将刷新 的临界点
        CGFloat normal2pullingOffsetY = happenOffsetY - self.mj_h;
        CGFloat pullingPercent = (happenOffsetY - offsetY) / self.mj_h;
        
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
    
    if (self.state != MJRefreshStateIdle) return;
    
    UIGestureRecognizerState panState = _scrollView.panGestureRecognizer.state;
    
    switch (panState) {
        // 手松开
        case UIGestureRecognizerStateEnded: {
            if (_scrollView.mj_insetT + _scrollView.mj_contentH <= _scrollView.mj_h) {  // 不够一个屏幕
                if (_scrollView.mj_offsetY >= - _scrollView.mj_insetT) { // 向上拽
                    self.triggerByDrag = YES;
                    [self beginRefreshing];
                }
            } else { // 超出一个屏幕
                if (_scrollView.mj_offsetY >= _scrollView.mj_contentH + _scrollView.mj_insetB - _scrollView.mj_h) {
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
                    self.scrollView.mj_offsetY = self.scrollView.mj_offsetY;
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
            self.scrollView.mj_insetT += self.insetTDelta;
            
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
    
    self.scrollView.mj_insetT += self.insetTDelta;
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
//        MJRefreshDispatchAsyncOnMainQueue({
            [UIView animateWithDuration:self.fastAnimationDuration animations:^{
                if (self.scrollView.panGestureRecognizer.state != UIGestureRecognizerStateCancelled) {
                    CGFloat top = self.scrollViewOriginalInset.top + self.mj_h;
                    // 增加滚动区域top
                    self.scrollView.mj_insetT = top;
                    // 设置滚动位置
                    CGPoint offset = self.scrollView.contentOffset;
                    offset.y = -top;
                    [self.scrollView setContentOffset:offset animated:NO];
                }
            } completion:^(BOOL finished) {
                [self executeRefreshingCallback];
            }];
//        })
        return;
    }
    
    if (self.scrollView.panGestureRecognizer.state != UIGestureRecognizerStateCancelled) {
        CGFloat top = self.scrollViewOriginalInset.top + self.mj_h;
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
    self.mj_xy = - self.mj_wh - self.ignoredScrollViewContentInsetDeta;
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
