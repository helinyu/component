//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  MJRefreshComponent.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/4.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJRefreshComponent.h"
#import "MJRefreshConst.h"

@interface MJRefreshComponent()
@property (strong, nonatomic) UIPanGestureRecognizer *pan;
@end

@implementation MJRefreshComponent

- (void)setAsxi_x:(CGFloat)asxi_x {
    self.horizontalDirection? (self.mj_y = asxi_x): (self.mj_x = asxi_x);
}

- (CGFloat)asxi_x {
    return self.horizontalDirection? self.mj_y: self.mj_x;
}

- (CGFloat)asxi_y {
    return self.horizontalDirection? self.mj_x : self.mj_y;
}

- (void)setAsxi_y:(CGFloat)asxi_y {
    self.horizontalDirection? (self.mj_x = asxi_y) :(self.mj_y = asxi_y);
}

- (void)setAsxi_width:(CGFloat)asxi_width {
    self.horizontalDirection? (self.mj_h = asxi_width): (self.mj_w = asxi_width);
}

- (CGFloat)asxi_width {
    return (self.horizontalDirection? self.mj_h :self.mj_w);
}

- (void)setAsxi_height:(CGFloat)asxi_height {
    self.horizontalDirection? (self.mj_w = asxi_height): (self.mj_h = asxi_height);
}

- (CGFloat)asxi_height {
    return (self.horizontalDirection? self.mj_w: self.mj_h);
}

- (CGFloat)scroll_asxi_width {
    return (self.horizontalDirection? self.scrollView.mj_h: self.scrollView.mj_w);
}

- (void)setScroll_asxi_width:(CGFloat)scroll_asxi_width  {
    self.horizontalDirection? (self.scrollView.mj_h = scroll_asxi_width):(self.scrollView.mj_w = scroll_asxi_width);
}

- (CGFloat)scroll_asix_height {
    return (self.horizontalDirection? self.scrollView.mj_w:self.scrollView.mj_h);
}

- (void)setScroll_asix_height:(CGFloat)scroll_asix_height {
    self.horizontalDirection? (self.scrollView.mj_w = scroll_asix_height):(self.scrollView.mj_h = scroll_asix_height);
}

- (CGFloat)scroll_asix_offset_y {
    return self.horizontalDirection? self.scrollView.mj_offsetX : self.scrollView.mj_offsetY;
}

- (void)setScroll_asix_offset_y:(CGFloat)scroll_asix_offset_y {
    self.horizontalDirection? (self.scrollView.mj_offsetX = scroll_asix_offset_y) :(self.scrollView.mj_offsetY = scroll_asix_offset_y);
}

- (CGFloat)scroll_asix_inset_top {
    return self.horizontalDirection? self.scrollView.mj_insetL : self.scrollView.mj_insetT;
}

- (void)setScroll_asix_inset_top:(CGFloat)scroll_asix_inset_top {
    self.horizontalDirection? (self.scrollView.mj_insetL = scroll_asix_inset_top):(self.scrollView.mj_insetT = scroll_asix_inset_top);
}

- (CGFloat)scroll_asxi_content_width {
    return self.horizontalDirection? self.scrollView.mj_contentH:self.scrollView.mj_contentW;
}

- (void)setScroll_asxi_content_width:(CGFloat)scroll_asxi_content_width {
    self.horizontalDirection? (self.scrollView.mj_contentH = scroll_asxi_content_width):(self.scrollView.mj_contentW = scroll_asxi_content_width);
}

- (CGFloat)scroll_asxi_content_height {
    return self.horizontalDirection? self.scrollView.mj_contentW:self.scrollView.mj_contentH;
}

- (void)setScroll_asxi_content_height:(CGFloat)scroll_asxi_content_height {
    self.horizontalDirection? (self.scrollView.mj_contentW = scroll_asxi_content_height):(self.scrollView.mj_contentH = scroll_asxi_content_height);
}

- (CGFloat)scroll_asix_origin_Inset_top {
    return self.horizontalDirection? self.scrollViewOriginalInset.left:self.scrollViewOriginalInset.top;
}

- (void)setScroll_asix_origin_Inset_top:(CGFloat)scroll_asix_origin_Inset_top {
    self.horizontalDirection? (self.scrollView.mj_insetL = scroll_asix_origin_Inset_top):( self.scrollView.mj_insetT = scroll_asix_origin_Inset_top);
}

- (CGFloat)scroll_asix_origin_Inset_bottom {
    return self.horizontalDirection? self.scrollViewOriginalInset.right:self.scrollViewOriginalInset.bottom;
}

- (void)setScroll_asix_origin_Inset_bottom:(CGFloat)scroll_asix_origin_Inset_bottom {
    self.horizontalDirection? (self.scrollView.mj_insetR = scroll_asix_origin_Inset_bottom):(self.scrollView.mj_insetB = scroll_asix_origin_Inset_bottom);
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 准备工作
        [self prepare];
        
        // 默认是普通状态
        self.state = MJRefreshStateIdle;
        self.fastAnimationDuration = 0.25;
        self.slowAnimationDuration = 0.4;
    }
    return self;
}

- (void)prepare
{
    // 基本属性
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews
{
    [self placeSubviews];
    
    [super layoutSubviews];
}

- (void)placeSubviews{}




- (void)configBouces {
    if (self.horizontalDirection) {
        self.scrollView.alwaysBounceHorizontal = YES;
        self.scrollView.alwaysBounceVertical = NO;
    }
    else {
        self.scrollView.alwaysBounceHorizontal = NO;
        self.scrollView.alwaysBounceVertical = YES;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    // 旧的父控件移除监听
    [self removeObservers];
    
    if (newSuperview) { // 新的父控件
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        _scrollViewOriginalInset = _scrollView.mj_inset;
        
        self.asxi_width = self.scroll_asxi_width;
        self.asxi_x = - self.scroll_asix_origin_Inset_top; 

        [self configBouces];
        
        // 添加监听
        [self addObservers];
    }
}


// 绘制的时候调用， 快要绘制了， 所以这个将要刷新的操作

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.state == MJRefreshStateWillRefresh) {
        // 预防view还没显示出来就调用了beginRefreshing
        self.state = MJRefreshStateRefreshing;
    }
}

#pragma mark - KVO监听
- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:MJRefreshKeyPathContentOffset options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:MJRefreshKeyPathContentSize options:options context:nil];
    
    self.pan = self.scrollView.panGestureRecognizer;
    [self.pan addObserver:self forKeyPath:MJRefreshKeyPathPanState options:options context:nil];
}

- (void)removeObservers
{
    [self.superview removeObserver:self forKeyPath:MJRefreshKeyPathContentOffset];
    [self.superview removeObserver:self forKeyPath:MJRefreshKeyPathContentSize];
    [self.pan removeObserver:self forKeyPath:MJRefreshKeyPathPanState];
    self.pan = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 遇到这些情况就直接返回
    if (!self.userInteractionEnabled) return;
    
    // 这个就算看不见也需要处理
    if ([keyPath isEqualToString:MJRefreshKeyPathContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    }
    
    // 看不见
    if (self.hidden) return;
    if ([keyPath isEqualToString:MJRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    } else if ([keyPath isEqualToString:MJRefreshKeyPathPanState]) {
        [self scrollViewPanStateDidChange:change];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{}
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{}
- (void)scrollViewPanStateDidChange:(NSDictionary *)change{}

#pragma mark - 公共方法
#pragma mark 设置回调对象和回调方法
- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    self.refreshingTarget = target;
    self.refreshingAction = action;
}

- (void)setState:(MJRefreshState)state
{
    _state = state;
    
    // 加入主队列的目的是等setState:方法调用完毕、设置完文字后再去布局子控件
    MJRefreshDispatchAsyncOnMainQueue([self setNeedsLayout];)
}

#pragma mark 进入刷新状态
- (void)beginRefreshing
{
    [UIView animateWithDuration:self.fastAnimationDuration animations:^{
        self.alpha = 1.0;
    }];
    self.pullingPercent = 1.0;
    // 只要正在刷新，就完全显示
    if (self.window) {
        self.state = MJRefreshStateRefreshing; // 设置它的状态， 这个bigin的刷新的内容
    } else {
        // 预防正在刷新中时，调用本方法使得header inset回置失败
        if (self.state != MJRefreshStateRefreshing) {
            self.state = MJRefreshStateWillRefresh;
            // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
            [self setNeedsDisplay];
        }
    }
}

- (void)beginRefreshingWithCompletionBlock:(void (^)(void))completionBlock
{
    self.beginRefreshingCompletionBlock = completionBlock;
    
    [self beginRefreshing];
}

#pragma mark 结束刷新状态
- (void)endRefreshing
{
    MJRefreshDispatchAsyncOnMainQueue(self.state = MJRefreshStateIdle;)
}

- (void)endRefreshingWithCompletionBlock:(void (^)(void))completionBlock
{
    self.endRefreshingCompletionBlock = completionBlock;
    
    [self endRefreshing];
}

#pragma mark 是否正在刷新
- (BOOL)isRefreshing
{
    return self.state == MJRefreshStateRefreshing || self.state == MJRefreshStateWillRefresh;
}

#pragma mark 自动切换透明度
- (void)setAutoChangeAlpha:(BOOL)autoChangeAlpha
{
    self.automaticallyChangeAlpha = autoChangeAlpha;
}

- (BOOL)isAutoChangeAlpha
{
    return self.isAutomaticallyChangeAlpha;
}

- (void)setAutomaticallyChangeAlpha:(BOOL)automaticallyChangeAlpha
{
    _automaticallyChangeAlpha = automaticallyChangeAlpha;
    
    if (self.isRefreshing) return;
    
    if (automaticallyChangeAlpha) {
        self.alpha = self.pullingPercent;
    } else {
        self.alpha = 1.0;
    }
}

#pragma mark 根据拖拽进度设置透明度
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    _pullingPercent = pullingPercent;
    
    if (self.isRefreshing) return;
    
    if (self.isAutomaticallyChangeAlpha) {
        self.alpha = pullingPercent;
    }
}

#pragma mark - 内部方法
- (void)executeRefreshingCallback
{
    MJRefreshDispatchAsyncOnMainQueue({
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
        if ([self.refreshingTarget respondsToSelector:self.refreshingAction]) {
            MJRefreshMsgSend(MJRefreshMsgTarget(self.refreshingTarget), self.refreshingAction, self);
        }
        if (self.beginRefreshingCompletionBlock) {
            self.beginRefreshingCompletionBlock();
        }
    })
}

#pragma mark - 刷新动画时间控制
- (instancetype)setAnimationDisabled {
    self.fastAnimationDuration = 0;
    self.slowAnimationDuration = 0;
    
    return self;
}


@end

#pragma mark - <<< 为 Swift 扩展链式语法 >>> -
@implementation MJRefreshComponent (ChainingGrammar)

- (instancetype)autoChangeTransparency:(BOOL)isAutoChange {
    self.automaticallyChangeAlpha = isAutoChange;
    return self;
}
- (instancetype)afterBeginningAction:(MJRefreshComponentAction)action {
    self.beginRefreshingCompletionBlock = action;
    return self;
}
- (instancetype)endingAnimationBeginningAction:(MJRefreshComponentAction)action {
    self.endRefreshingAnimationBeginAction = action;
    return self;
}
- (instancetype)afterEndingAction:(MJRefreshComponentAction)action {
    self.endRefreshingCompletionBlock = action;
    return self;
}

- (instancetype)linkTo:(UIScrollView *)scrollView {
    return self;
}

@end
