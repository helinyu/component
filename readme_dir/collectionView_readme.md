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
// 滑动到目标的位置 （用于监控滑动停止的位置）
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


<!--   -->
是在这个设置属性的环境下： //        self.collectionView.allowsMultipleSelectionDuringEditing = YES;
// iOS 13 两个手指新增的状态 （感觉没有多大的使用， 需要两个手指，最后还是选择了一个，并没有多少）
// 多选， 允许两个手指pan手势自动启动allowsMultipleSelection 和开始多选cells
// 当multi-select 手势被是写只有，这个方法将会被调用在allowsMultipleSelection之前
// YES 允许你永辉通过two-finger 手势滑动
//如果collection  view 没有包括滑动的方向， （collection  view 滑动在水平和方向上）， 这个方法将会不被调用和多选实现将失败
// 如果这个方法没有实现，默认是NO
- (BOOL)collectionView:(UICollectionView *)collectionView shouldBeginMultipleSelectionInteractionAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos) {
    NSLog(@"lt - shouldBeginMultipleSelectionInteractionAtIndexPath");
    return YES;
}

// 这个方法在allowsMultipleSelection 设置为YES之后，如果-collectionView:shouldBeginMultipleSelectionInteractionAtIndexPath: return YES,
// 这个是一个号的机会去更新你的UI状态和反应用户现在选择的这是反应
//一旦多选多个， 例如： 更新按钮donw， 替换select/Edit
- (void)collectionView:(UICollectionView *)collectionView didBeginMultipleSelectionInteractionAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos) {
    NSLog(@"lt - didBeginMultipleSelectionInteractionAtIndexPath");
}

// 表示我们的多选的手势交互已经关闭了
- (void)collectionViewDidEndMultipleSelectionInteraction:(UICollectionView *)collectionView API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos); {
    NSLog(@"lt - collectionViewDidEndMultipleSelectionInteraction");
}

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
// 弹出来的交互不知道怎么弄好， 感觉这个操作还是不太行

// 开始条用，弹出菜单的时候， 返回一个UITargetedPreview 界面，米哦按技术需要的高亮的预览页面
- (nullable UITargetedPreview *)collectionView:(UICollectionView *)collectionView previewForHighlightingContextMenuWithConfiguration:(UIContextMenuConfiguration *)configuration API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(watchos, tvos);
{
    NSValue *startValue = [NSValue valueWithCGRect:CGRectMake(0.f, 0.f, 40.f, 40.f)];
    UIPreviewParameters *parameters = [[UIPreviewParameters alloc] initWithTextLineRects:@[startValue]];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 100.f, 100.f)];
    view.backgroundColor = [UIColor greenColor];
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(100.f, 100.f,  200.f, 200.f)];
    containerView.backgroundColor = [UIColor brownColor];
    [self.view addSubview:containerView];
    UIPreviewTarget *previewTarget = [[UIPreviewTarget alloc] initWithContainer:containerView center:CGPointMake(10.f, 10.f)];
    UITargetedPreview *targetPreview = [[UITargetedPreview alloc] initWithView:view parameters:parameters target:previewTarget];
    return targetPreview;
}
/*!
* @abstract Called when the collection view is about to display a menu.
*
* @param collectionView  This UICollectionView.
* @param configuration   The configuration of the menu about to be displayed.
* @param animator        Appearance animator. Add animations to run them alongside the appearance transition.
*/
- (void)collectionView:(UICollectionView *)collectionView willDisplayContextMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(nullable id<UIContextMenuInteractionAnimating>)animator API_AVAILABLE(ios(13.2)) API_UNAVAILABLE(watchos, tvos);


/*!
* @abstract Called when the interaction is about to dismiss. Return a UITargetedPreview describing the desired dismissal target.
* The interaction will animate the presented menu to the target. Use this to customize the dismissal animation.
*
* @param collectionView  This UICollectionView.
* @param configuration   The configuration of the menu displayed by this interaction.
*/
- (nullable UITargetedPreview *)collectionView:(UICollectionView *)collectionView previewForDismissingContextMenuWithConfiguration:(UIContextMenuConfiguration *)configuration API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(watchos, tvos);

/*!
* @abstract Called when the interaction is about to "commit" in response to the user tapping the preview.
*
* @param collectionView  This UICollectionView.
* @param configuration   Configuration of the currently displayed menu.
* @param animator        Commit animator. Add animations to this object to run them alongside the commit transition.
*/
- (void)collectionView:(UICollectionView *)collectionView willPerformPreviewActionForMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionCommitAnimating>)animator API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(watchos, tvos);


/*!
* @abstract Called when the collection view's context menu interaction is about to end.
*
* @param collectionView  This UICollectionView.
* @param configuration   Ending configuration.
* @param animator        Disappearance animator. Add animations to run them alongside the disappearance transition.
*/
- (void)collectionView:(UICollectionView *)collectionView willEndContextMenuInteractionWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(nullable id<UIContextMenuInteractionAnimating>)animator API_AVAILABLE(ios(13.2)) API_UNAVAILABLE(watchos, tvos);

// 这个五个方法， 执行的时间段 
2021-01-27 11:25:35.882302+0800 testVC[14539:106208] previewForHighlightingContextMenuWithConfiguration // 配置高亮的图片
2021-01-27 11:25:36.470138+0800 testVC[14539:106208] willDisplayContextMenuWithConfiguration 
2021-01-27 11:25:37.655335+0800 testVC[14539:106208] willPerformPreviewActionForMenuWithConfiguration
2021-01-27 11:25:37.659676+0800 testVC[14539:106208] willEndContextMenuInteractionWithConfiguration
2021-01-27 11:25:37.659871+0800 testVC[14539:106208] previewForDismissingContextMenuWithConfiguration
// 惨淡好像并没有看到， 这个有时间再去看看 ， iOS 13 弹出来的一个功能，但是弹出来的时候， 这个东西的交互要怎么才有，好像只是弹出来而已； 如果我要加入更多复杂的交互，回事怎么样的呢？


```

```
// 不知道这个编辑的是什么
iOS 14特有的特性，那么iOS14之前是怎么实现的？
// 表示是否可以滑动 ， YES：表示可以修改， NO：表示不可以修改 
- (BOOL)collectionView:(UICollectionView *)collectionView canEditItemAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(14.0), tvos(14.0), watchos(7.0));

```
UISpringLoadedInteractionContext 这个应该是一个动画的展示
默认是YES， 允许选择spring 加载指定的item， 默认是cell 如果你想及哦啊胡影响到cell的subView，修改context.targetView  属性
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSpringLoadItemAtIndexPath:(NSIndexPath *)indexPath withContext:(id<UISpringLoadedInteractionContext>)context API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos);
{
    return YES;
}
```


```

// 编辑状态
@property (nonatomic, getter=isEditing) BOOL editing API_AVAILABLE(ios(14.0), tvos(14.0), watchos(7.0));

 // 编辑的状态能够选择
@property (nonatomic) BOOL allowsSelectionDuringEditing API_AVAILABLE(ios(14.0), tvos(14.0), watchos(7.0));

 // 在编辑的时候，设置
@property (nonatomic) BOOL allowsMultipleSelectionDuringEditing API_AVAILABLE(ios(14.0), tvos(14.0), watchos(7.0));



``

```
    self.collectionView.allowsSelection = YES;
    self.collectionView.allowsMultipleSelection  = YES;
    // 如果没有编辑，上面两个属性设置就可以了， 但是如果有系统编辑， 需要设置下面的，

    if (@available(iOS 14.0, *)) {
        self.collectionView.allowsMultipleSelectionDuringEditing = YES; // 编辑状态， 好像系统有默认的编辑状态
        self.collectionView.editing = YES;
    } else {
        // Fallback on earlier versions
    }

// 多选， 允许两个手指pan手势自动启动allowsMultipleSelection 和开始多选cells
// 当multi-select 手势被是写只有，这个方法将会被调用在allowsMultipleSelection之前
// YES 允许你永辉通过two-finger 手势滑动
//如果collection  view 没有包括滑动的方向， （collection  view 滑动在水平和方向上）， 这个方法将会不被调用和多选实现将失败
// 如果这个方法没有实现，默认是NO
// 为什么我在设置为NO的时候也是可以的？ 这个在allowmultiSelection 之前执行的， 所以，如果allowsMultipleSelection = YES，那么这里设置为什么都不重要了
// 但是allowsMultipleSelection 设置为YES的时候，，才会有多个选择的效果， 下面这个只是选择的暂时效果
- (BOOL)collectionView:(UICollectionView *)collectionView shouldBeginMultipleSelectionInteractionAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos) {
    NSLog(@"lt - shouldBeginMultipleSelectionInteractionAtIndexPath");
    return self.canMultiEditSelected;
}

// 这个方法在allowsMultipleSelection 设置为YES之后，如果-collectionView:shouldBeginMultipleSelectionInteractionAtIndexPath: return YES,
// 这个是一个号的机会去更新你的UI状态和反应用户现在选择的这是反应
//一旦多选多个， 例如： 更新按钮donw， 替换select/Edit
- (void)collectionView:(UICollectionView *)collectionView didBeginMultipleSelectionInteractionAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos) {
    NSLog(@"lt - didBeginMultipleSelectionInteractionAtIndexPath");
}

// 表示我们的多选的手势交互已经关闭了
- (void)collectionViewDidEndMultipleSelectionInteraction:(UICollectionView *)collectionView API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos); {
    NSLog(@"lt - collectionViewDidEndMultipleSelectionInteraction");
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"lt - shouldSelectItemAtIndexPath");
    return !self.canMultiEditSelected;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"lt - didSelectItemAtIndexPath");
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath; // called when the user taps on an already-selected item in multi-select mode
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"lt - didDeselectItemAtIndexPath");
}

```

```
// 对应着我们的代理， 选择的时候移动的时候
@property (nonatomic) BOOL selectionFollowsFocus API_AVAILABLE(ios(14.0)) API_UNAVAILABLE(watchos, tvos);

```

```
// Drag & Drop

// 只读的状态
@property (nonatomic, readonly) BOOL hasActiveDrag API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos);
@property (nonatomic, readonly) BOOL hasActiveDrop API_AVAILABLE(ios(11.0)) API_UNAVAI

```


```
// iOS的拖拽的代理
API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos)
@protocol UICollectionViewDragDelegate <NSObject>

@required

 // 开始拖拽的方法
- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView itemsForBeginningDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath;

@optional

/* Called to request items to add to an existing drag session in response to the add item gesture.
 * You can use the provided point (in the collection view's coordinate space) to do additional hit testing if desired.
 * If not implemented, or if an empty array is returned, no items will be added to the drag and the gesture
 * will be handled normally.
 */
- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView itemsForAddingToDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point;

/* Allows customization of the preview used for the item being lifted from or cancelling back to the collection view.
 * If not implemented or if nil is returned, the entire cell will be used for the preview.
 */
- (nullable UIDragPreviewParameters *)collectionView:(UICollectionView *)collectionView dragPreviewParametersForItemAtIndexPath:(NSIndexPath *)indexPath;

/* Called after the lift animation has completed to signal the start of a drag session.
 * This call will always be balanced with a corresponding call to -collectionView:dragSessionDidEnd:
 */
- (void)collectionView:(UICollectionView *)collectionView dragSessionWillBegin:(id<UIDragSession>)session;

/* Called to signal the end of the drag session.
 */
- (void)collectionView:(UICollectionView *)collectionView dragSessionDidEnd:(id<UIDragSession>)session;


/* Controls whether move operations (see UICollectionViewDropProposal.operation) are allowed for the drag session.
 * If not implemented this will default to YES.
 */
- (BOOL)collectionView:(UICollectionView *)collectionView dragSessionAllowsMoveOperation:(id<UIDragSession>)session;

/* Controls whether the drag session is restricted to the source application.
 * If YES the current drag session will not be permitted to drop into another application.
 * If not implemented this will default to NO.
 */
- (BOOL)collectionView:(UICollectionView *)collectionView dragSessionIsRestrictedToDraggingApplication:(id<UIDragSession>)session;

@end

```

```
// 拖拽之后吸附的效果
API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos)
@protocol UICollectionViewDropDelegate <NSObject>

@required

/* Called when the user initiates the drop.
 * Use the dropCoordinator to specify how you wish to animate the dropSession's items into their final position as
 * well as update the collection view's data source with data retrieved from the dropped items.
 * If the supplied method does nothing, default drop animations will be supplied and the collection view will
 * revert back to its initial pre-drop session state.
 */
- (void)collectionView:(UICollectionView *)collectionView performDropWithCoordinator:(id<UICollectionViewDropCoordinator>)coordinator;

@optional

/* If NO is returned no further delegate methods will be called for this drop session.
 * If not implemented, a default value of YES is assumed.
 */
- (BOOL)collectionView:(UICollectionView *)collectionView canHandleDropSession:(id<UIDropSession>)session;

/* Called when the drop session begins tracking in the collection view's coordinate space.
 */
- (void)collectionView:(UICollectionView *)collectionView dropSessionDidEnter:(id<UIDropSession>)session;

/* Called frequently while the drop session being tracked inside the collection view's coordinate space.
 * When the drop is at the end of a section, the destination index path passed will be for a item that does not yet exist (equal
 * to the number of items in that section), where an inserted item would append to the end of the section.
 * The destination index path may be nil in some circumstances (e.g. when dragging over empty space where there are no cells).
 * Note that in some cases your proposal may not be allowed and the system will enforce a different proposal.
 * You may perform your own hit testing via -[UIDropSession locationInView]
 */
- (UICollectionViewDropProposal *)collectionView:(UICollectionView *)collectionView dropSessionDidUpdate:(id<UIDropSession>)session withDestinationIndexPath:(nullable NSIndexPath *)destinationIndexPath;

/* Called when the drop session is no longer being tracked inside the collection view's coordinate space.
 */
- (void)collectionView:(UICollectionView *)collectionView dropSessionDidExit:(id<UIDropSession>)session;

/* Called when the drop session completed, regardless of outcome. Useful for performing any cleanup.
 */
- (void)collectionView:(UICollectionView *)collectionView dropSessionDidEnd:(id<UIDropSession>)session;

/* Allows customization of the preview used for the item being dropped.
 * If not implemented or if nil is returned, the entire cell will be used for the preview.
 *
 * This will be called as needed when animating drops via -[UICollectionViewDropCoordinator dropItem:toItemAtIndexPath:]
 * (to customize placeholder drops, please see UICollectionViewDropPlaceholder.previewParametersProvider)
 */
- (nullable UIDragPreviewParameters *)collectionView:(UICollectionView *)collectionView dropPreviewParametersForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

```

// drag 和drop更多的是使用在ipad上的效果；


数据源的接口
@protocol UICollectionViewDataSource <NSObject>
@required

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(9.0));
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath API_AVAILABLE(ios(9.0));

/// Returns a list of index titles to display in the index view (e.g. ["A", "B", "C" ... "Z", "#"])
- (nullable NSArray<NSString *> *)indexTitlesForCollectionView:(UICollectionView *)collectionView API_AVAILABLE(tvos(10.2));

/// Returns the index path that corresponds to the given title / index. (e.g. "B",1)
/// Return an index path with a single index to indicate an entire section, instead of a specific item.
- (NSIndexPath *)collectionView:(UICollectionView *)collectionView indexPathForIndexTitle:(NSString *)title atIndex:(NSInteger)index API_AVAILABLE(tvos(10.2));

@end

@protocol UICollectionViewDataSourcePrefetching <NSObject>
@required
// indexPaths are ordered ascending by geometric distance from the collection view
<!-- 与获取数据 -->
- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths API_AVAILABLE(ios(10.0));

@optional
// indexPaths that previously were considered as candidates for pre-fetching, but were not actually used; may be a subset of the previous call to -collectionView:prefetchItemsAtIndexPaths:
<!--  与上面的内容，对应，是否要预先取消某个IndexPaths -->
- (void)collectionView:(UICollectionView *)collectionView cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths  API_AVAILABLE(ios(10.0));

@end

```
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong) UICollectionViewLayout *collectionViewLayout;// 布局
@property (nonatomic, weak, nullable) id <UICollectionViewDelegate> delegate; // 行为
@property (nonatomic, weak, nullable) id <UICollectionViewDataSource> dataSource; // 数据源

@property (nonatomic, weak, nullable) id<UICollectionViewDataSourcePrefetching> prefetchDataSource API_AVAILABLE(ios(10.0)); //预取数据源
@property (nonatomic, getter=isPrefetchingEnabled) BOOL prefetchingEnabled API_AVAILABLE(ios(10.0)); //是否开启月线获取的能力

@property (nonatomic, weak, nullable) id <UICollectionViewDragDelegate> dragDelegate API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos); // 拖拽
@property (nonatomic, weak, nullable) id <UICollectionViewDropDelegate> dropDelegate API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos); //吸附的效果

/* To enable intra-app drags on iPhone, set this to YES.
 * You can also force drags to be disabled for this collection view by setting this to NO.
 * By default, For iPad this will return YES and iPhone will return NO.
 */
@property (nonatomic) BOOL dragInteractionEnabled API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos); /// 拖拽的开关

@property (nonatomic, readonly, nullable) UIContextMenuInteraction *contextMenuInteraction API_UNAVAILABLE(ios) API_UNAVAILABLE(watchos, tvos); // 交互的上下文

@property (nonatomic) UICollectionViewReorderingCadence reorderingCadence API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos);
 是否追踪我们的cell移动的时候, 默认：UICollectionViewReorderingCadenceImmediate

@property (nonatomic, strong, nullable) UIView *backgroundView;
collectionView 只有有一个背景的View

```

```
// For each reuse identifier that the collection view will use, register either a class or a nib from which to instantiate a cell.
// If a nib is registered, it must contain exactly 1 top level object which is a UICollectionViewCell.
// If a class is registered, it will be instantiated via alloc/initWithFrame:

// 要重用一个cell实例， 必须要先注册
// nib注册， 它必须包括1级水平对象的collectionViewCell
// class 注册，将通过 alloc/initWithFrame: 初始化

// 注册cell内容，
- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(nullable UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;

// xib的注册方式
- (void)registerClass:(nullable Class)viewClass forSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(nullable UINib *)nib forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier;

// 重用方式
- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (__kindof UICollectionReusableView *)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

// ios 14 重用方式 (这个方法是更加的好重用这个内容， 这样子的话， collectionView 就不用我们每次都去deque什么了，直接使用了这个东西)
// 这个地方， 对iOS 14 之前进行兼容了， 很多tableView的东西，进行处理datasource 方面的内容
- (__kindof UICollectionViewCell *)dequeueConfiguredReusableCellWithRegistration:(UICollectionViewCellRegistration*)registration forIndexPath:(NSIndexPath*)indexPath item:(id)item API_AVAILABLE(ios(14.0),tvos(14.0));
- (__kindof UICollectionReusableView *)dequeueConfiguredReusableSupplementaryViewWithRegistration:(UICollectionViewSupplementaryRegistration*)registration forIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(14.0),tvos(14.0));

可以看一下基本的组件
https://github.com/helinyu/component/tree/main/collectionViewLayout/ListView

```

