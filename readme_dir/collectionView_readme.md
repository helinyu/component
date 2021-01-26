UITableview 相当于一个简化版的UICollectionView  ， collectionView 还可以自定义布局

1、UICollectionViewDatasource, UICollectionViewDelegate, UICollectionViewLayout
UICollectionViewDatasource 这个只是和数据源有关系， 和布局毫无关系
UICollectionViewLayout 里面就是有对应的方法
UICollectionViewDelegate 用户的交互行为的代理， 和layout是紧密关系的 
> 自定义布局，都是可以仿照系统给出的UICollectionViewFlowLayout 进行写

有关的布局的示例可以查看控件： 
[自定义布局](https://github.com/helinyu/component/tree/main/collectionViewLayout)

可以通过解析flowLayout 进行理解各个属性的内容 ；

#0x00 UICollectionView
```
 // 将目标的Cell移动到CollectionView的左边、右边、下边、中间 (水平、垂直)。。。
typedef NS_OPTIONS(NSUInteger, UICollectionViewScrollPosition) {
    UICollectionViewScrollPositionNone                 = 0,
    
// 垂直方向他们之间是互斥的， 但是在水片滑动方向可能是可以的同事存在的按位或运算
 // 组合相同组（垂直或水平）将导致不一致的错误 
// eg：如果水平方向， 使用或运算就会出现不一致的问题， 这个是在水平方向的时候才可以使用或运
    UICollectionViewScrollPositionTop                  = 1 << 0,
    UICollectionViewScrollPositionCenteredVertically   = 1 << 1, // 
    UICollectionViewScrollPositionBottom               = 1 << 2,
    
// 水平方向是互斥的，垂直方向是可以或运算的
    UICollectionViewScrollPositionLeft                 = 1 << 3,
    UICollectionViewScrollPositionCenteredHorizontally = 1 << 4,
    UICollectionViewScrollPositionRight                = 1 << 5
};

```
```
typedef NS_ENUM(NSInteger, UICollectionViewReorderingCadence) {
    UICollectionViewReorderingCadenceImmediate, // 立即
    UICollectionViewReorderingCadenceFast, // 快速
    UICollectionViewReorderingCadenceSlow // 慢
} API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos);
// 重新排序的节奏会影响在能够重新排序的放置目的地周围拖动时重新排序的容易程度。
// 重排节奏 ，  默认是UICollectionViewReorderingCadenceImmediate
// 也就是我们拖拽的时候的效果影响
@property (nonatomic) UICollectionViewReorderingCadence reorderingCadence API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos);
// 在iOS11 之后，系统实现了这些功能 ， 影响cell的额跟踪速度

/* To enable intra-app drags on iPhone, set this to YES.
 * You can also force drags to be disabled for this collection view by setting this to NO.

// YES： 允许拖拽在iphone 的App 里面， 
// ipad 默认是YES， iphone 默认是NO
@property (nonatomic) BOOL dragInteractionEnabled API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos);
// 有时间看一下在iOS11 之前是怎么实现这个功能的 ； 
```

```
涉及到的协议：
@protocol UIDataSourceTranslating, UISpringLoadedInteractionContext;
@protocol UIDragSession, UIDropSession;
@protocol UICollectionViewDragDelegate, UICollectionViewDropDelegate, UICollectionViewDropCoordinator, UICollectionViewDropItem, UICollectionViewDropPlaceholderContext;
```
```
涉及到类
# 涉及到的这些类， 要注意了解每个类的使用情况
@class UICollectionView, UICollectionReusableView, UICollectionViewCell, UICollectionViewLayout, UICollectionViewTransitionLayout, UICollectionViewLayoutAttributes, UITouch, UINib;
@class UIDragItem, UIDragPreviewParameters, UIDragPreviewTarget;
@class UICollectionViewDropProposal, UICollectionViewPlaceholder, UICollectionViewDropPlaceholder;
@class UICollectionViewCellRegistration, UICollectionViewSupplementaryRegistration;
```

```
布局转场的block签名， 这个有什么作用
typedef void (^UICollectionViewLayoutInteractiveTransitionCompletion)(BOOL completed, BOOL finished);

```
```
// 这个需要重点去研究一下示例
// 这个是转场的效果， 这个更多的和已启动的viewcontroller跳转进行使用
- (UICollectionViewTransitionLayout *)startInteractiveTransitionToCollectionViewLayout:(UICollectionViewLayout *)layout completion:(nullable UICollectionViewLayoutInteractiveTransitionCompletion)completion API_AVAILABLE(ios(7.0));
- (void)finishInteractiveTransition API_AVAILABLE(ios(7.0));
- (void)cancelInteractiveTransition API_AVAILABLE(ios(7.0));

// support for custom transition layout
// 支持自定义的transition 布局
- (nonnull UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout;

https://www.coder.work/article/291688

```
```
collectionView 我们在写有关移动cell的时候的方法， 这个是移动
reorderingCadence 这个属性，影响到cell的切换的速度快慢， 跟踪的快慢
- (BOOL)beginInteractiveMovementForItemAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(9.0)); // returns NO if reordering was prevented from beginning - otherwise YES
- (void)updateInteractiveMovementTargetPosition:(CGPoint)targetPosition API_AVAILABLE(ios(9.0));
- (void)endInteractiveMovement API_AVAILABLE(ios(9.0));
- (void)cancelInteractiveMovement API_AVAILABLE(ios(9.0));

//  这个是iOS 9 之后移动的方法， iOS 9 之前使用上面的方法和手势去实现
- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath API_AVAILABLE(ios(9.0));
```


```
// 滑动到目标的位置
- (CGPoint)collectionView:(UICollectionView *)collectionView targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset API_AVAILABLE(ios(9.0)); // customize the content offset to be applied during transition or update animations
移动过程中,会不断的调用这个方法,  originalIndexPath 能否移动到proposedIndexPath , 如果不重写的话,会默认返回proposedIndexPath;   可以通过返回nil, 告知系统不可以移动到此位置 

```

```
// 不知道为什么，这个没有执行到， 看一下什么场景使用到，在iOS中
// 应该是目标更新的上下文 ——
UIKIT_EXTERN API_AVAILABLE(ios(9.0)) @interface UICollectionViewFocusUpdateContext : UIFocusUpdateContext

@property (nonatomic, strong, readonly, nullable) NSIndexPath *previouslyFocusedIndexPath;
@property (nonatomic, strong, readonly, nullable) NSIndexPath *nextFocusedIndexPath;

@end

// collectionViewDelegate 里面的方法
// Focus
- (BOOL)collectionView:(UICollectionView *)collectionView canFocusItemAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(9.0));
- (BOOL)collectionView:(UICollectionView *)collectionView shouldUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context API_AVAILABLE(ios(9.0));
- (void)collectionView:(UICollectionView *)collectionView didUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator API_AVAILABLE(ios(9.0));
- (nullable NSIndexPath *)indexPathForPreferredFocusedViewInCollectionView:(UICollectionView *)collectionView API_AVAILABLE(ios(9.0));

```

```
// 将会展示的cell
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(8.0));
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(8.0));

// 已经消失的cell
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath;

```
```
// 用户点击的的时候通知 selection/deselection 和 highlight/unhighlight事件
// 用户的点击导致的时序是
// 触摸开始的时候
// 1. -collectionView:shouldHighlightItemAtIndexPath:
// 2. -collectionView:didHighlightItemAtIndexPath:
//
// 手指离开的时候
// 3. -collectionView:shouldSelectItemAtIndexPath: or -collectionView:shouldDeselectItemAtIndexPath:
// 4. -collectionView:didSelectItemAtIndexPath: or -collectionView:didDeselectItemAtIndexPath:
// 5. -collectionView:didUnhighlightItemAtIndexPath:

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath; // 只有在多选(multi-select)模式下， 点击才会调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath; // 单选都会调用， 多选根据上面情况而定
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;
// 注意单选和多选的操作环境

// 是否可以选择， 是否可以多选的
@property (nonatomic) BOOL allowsSelection; //默认YES， YES: 可以点击， NO不可以点击 , 上面的这几个方法都是不会执行的
@property (nonatomic) BOOL allowsMultipleSelection; // 默认是NO， YES: 可以多选， NO: 不可以多选

// 多选： allowsMultipleSelection = YES ; 的时候执行的顺序
// 点击没有点过的cell
2021-01-26 17:38:23.499448+0800 testVC[33970:422740] lt - shouldHighlightItemAtIndexPath
2021-01-26 17:38:23.499623+0800 testVC[33970:422740] lt - didHighlightItemAtIndexPath
2021-01-26 17:38:23.499769+0800 testVC[33970:422740] lt - didUnhighlightItemAtIndexPath
2021-01-26 17:38:23.499854+0800 testVC[33970:422740] lt - shouldSelectItemAtIndexPath
2021-01-26 17:38:23.499979+0800 testVC[33970:422740] lt - didSelectItemAtIndexPath

//  点击点过的cell
2021-01-26 17:38:38.739881+0800 testVC[33970:422740] lt - shouldHighlightItemAtIndexPath
2021-01-26 17:38:38.740050+0800 testVC[33970:422740] lt - didHighlightItemAtIndexPath
2021-01-26 17:38:38.740155+0800 testVC[33970:422740] lt - didUnhighlightItemAtIndexPath
2021-01-26 17:38:38.740248+0800 testVC[33970:422740] lt - shouldDeselectItemAtIndexPath
2021-01-26 17:38:38.740455+0800 testVC[33970:422740] lt - didDeselectItemAtIndexPath


// 单选： allowsMultipleSelection = NO;
// 第一次点击 ，或者点击上一次上一次点击的
2021-01-26 17:40:50.890774+0800 testVC[34139:425790] lt - shouldHighlightItemAtIndexPath
2021-01-26 17:40:50.890942+0800 testVC[34139:425790] lt - didHighlightItemAtIndexPath
2021-01-26 17:40:50.891058+0800 testVC[34139:425790] lt - didUnhighlightItemAtIndexPath
2021-01-26 17:40:50.891145+0800 testVC[34139:425790] lt - shouldSelectItemAtIndexPath
2021-01-26 17:40:50.891296+0800 testVC[34139:425790] lt - didSelectItemAtIndexPath

//  第二次点击， 多了一个didDeselectItemAtIndexPath
2021-01-26 17:41:11.722544+0800 testVC[34139:425790] lt - shouldHighlightItemAtIndexPath
2021-01-26 17:41:11.722720+0800 testVC[34139:425790] lt - didHighlightItemAtIndexPath
2021-01-26 17:41:11.722837+0800 testVC[34139:425790] lt - didUnhighlightItemAtIndexPath
2021-01-26 17:41:11.722909+0800 testVC[34139:425790] lt - shouldSelectItemAtIndexPath
2021-01-26 17:41:11.723022+0800 testVC[34139:425790] lt - didDeselectItemAtIndexPath
2021-01-26 17:41:11.723140+0800 testVC[34139:425790] lt - didSelectItemAtIndexPath

PS：
1）hightlight 的范围没有什么变化， 
2）但是selected有所拜年话， 包括：shouldSelectItemAtIndexPath 和 didDeselectItemAtIndexPath 方法

```

```
// These methods provide support for copy/paste actions on cells.
// All three should be implemented if any are.
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath API_DEPRECATED_WITH_REPLACEMENT("collectionView:contextMenuConfigurationForItemAtIndexPath:", ios(6.0, 13.0));
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender API_DEPRECATED_WITH_REPLACEMENT("collectionView:contextMenuConfigurationForItemAtIndexPath:", ios(6.0, 13.0));
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender API_DEPRECATED_WITH_REPLACEMENT("collectionView:contextMenuConfigurationForItemAtIndexPath:", ios(6.0, 13.0));


/*!
 * @abstract Called when the interaction begins.
 *
 * @param collectionView  This UICollectionView.
 * @param indexPath       IndexPath of the item for which a configuration is being requested.
 * @param point           Location in the collection view's coordinate space
 *
 * @return A UIContextMenuConfiguration describing the menu to be presented. Return nil to prevent the interaction from beginning.
 *         Returning an empty configuration causes the interaction to begin then fail with a cancellation effect. You might use this
 *         to indicate to users that it's possible for a menu to be presented from this element, but that there are no actions to
 *         present at this particular time.
 */
- (nullable UIContextMenuConfiguration *)collectionView:(UICollectionView *)collectionView contextMenuConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(watchos, tvos);

// UIContextMenuConfiguration 这个类里面

```

```
// 按钮的处理 copy/paste 在cells上
// These methods provide support for copy/paste actions on cells.
// All three should be implemented if any are.
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath API_DEPRECATED_WITH_REPLACEMENT("collectionView:contextMenuConfigurationForItemAtIndexPath:", ios(6.0, 13.0)) {
    NSLog(@"lt - shouldShowMenuForItemAtIndexPath:");
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender API_DEPRECATED_WITH_REPLACEMENT("collectionView:contextMenuConfigurationForItemAtIndexPath:", ios(6.0, 13.0));
{
    NSLog(@"lt - canPerformAction:forItemAtIndexPath:withSender");
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender API_DEPRECATED_WITH_REPLACEMENT("collectionView:contextMenuConfigurationForItemAtIndexPath:", ios(6.0, 13.0));
{
    NSLog(@"lt - performAction:forItemAtIndexPath:withSender");
}

 // 这个不知道怎么使用
- (nullable UIContextMenuConfiguration *)collectionView:(UICollectionView *)collectionView contextMenuConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(watchos, tvos);
{
    UIContextMenuConfiguration *config = [UIContextMenuConfiguration configurationWithIdentifier:@"identifier" previewProvider:^UIViewController * _Nullable{
        UIViewController *vc = [UIViewController new];
        vc.title = @"名字";
        vc.view.backgroundColor = [UIColor greenColor];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:@"按钮按钮" forState:UIControlStateNormal];
        [vc.view addSubview:btn];
        btn.frame = CGRectMake(0.f, 0.f, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
        [btn addTarget:self action:@selector(onTest) forControlEvents:UIControlEventTouchUpInside];
        vc.view.userInteractionEnabled = NO;
        return vc;
    } actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        UIImage *img = [UIImage imageNamed:@"icon_chpater_list_limitfree"];
        UIMenu *menu = [UIMenu menuWithTitle:@"惨淡" image:img identifier:@"menu.identifier" options:UIMenuOptionsDisplayInline children:suggestedActions];
        return menu;
    }];
    
    return config;
}
//UIContextMenuConfiguration 菜单的配置， 这个还没有示例

```


