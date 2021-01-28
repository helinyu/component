```
UIKIT_EXTERN NSString *const UICollectionElementKindSectionHeader API_AVAILABLE(ios(6.0)); // 头部
UIKIT_EXTERN NSString *const UICollectionElementKindSectionFooter API_AVAILABLE(ios(6.0)); // 尾部

// 方向
typedef NS_ENUM(NSInteger, UICollectionViewScrollDirection) {
    UICollectionViewScrollDirectionVertical, //垂直
    UICollectionViewScrollDirectionHorizontal // 水平
};

// 重用View的类型
typedef NS_ENUM(NSUInteger, UICollectionElementCategory) {
    UICollectionElementCategoryCell, // cell 
    UICollectionElementCategorySupplementaryView, // sup
    UICollectionElementCategoryDecorationView //Decoration 这个好像没有怎么用过
};

```

```
@class UICollectionViewLayoutAttributes;
@class UICollectionView;
@class UINib;

// 属性
UIKIT_EXTERN API_AVAILABLE(ios(6.0)) @interface UICollectionViewLayoutAttributes : NSObject <NSCopying, UIDynamicItem>

@property (nonatomic) CGRect frame; // 位置大小
@property (nonatomic) CGPoint center; // 中心点
@property (nonatomic) CGSize size; // 大小
@property (nonatomic) CATransform3D transform3D; // 3D变换
@property (nonatomic) CGRect bounds API_AVAILABLE(ios(7.0)); // 大小
@property (nonatomic) CGAffineTransform transform API_AVAILABLE(ios(7.0));// 2D转换
@property (nonatomic) CGFloat alpha; // 透明度
@property (nonatomic) NSInteger zIndex; // default is 0 z轴
@property (nonatomic, getter=isHidden) BOOL hidden; // 是否影响这个属性，确定了是否显示
@property (nonatomic, strong) NSIndexPath *indexPath; // 索引

@property (nonatomic, readonly) UICollectionElementCategory representedElementCategory; // 显示的view的类型
@property (nonatomic, readonly, nullable) NSString *representedElementKind; // 当时UICollectionElementCategoryCell 的时候为nil

// 对应的三种view的创建属性的方法
+ (instancetype)layoutAttributesForCellWithIndexPath:(NSIndexPath *)indexPath; // 
+ (instancetype)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind withIndexPath:(NSIndexPath *)indexPath;
+ (instancetype)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind withIndexPath:(NSIndexPath *)indexPath;

@end

```


```
更新的类型
typedef NS_ENUM(NSInteger, UICollectionUpdateAction) {
    UICollectionUpdateActionInsert,
    UICollectionUpdateActionDelete,
    UICollectionUpdateActionReload,
    UICollectionUpdateActionMove,
    UICollectionUpdateActionNone
};

// 更新对象
UIKIT_EXTERN API_AVAILABLE(ios(6.0)) @interface UICollectionViewUpdateItem : NSObject

@property (nonatomic, readonly, nullable) NSIndexPath *indexPathBeforeUpdate; // nil for UICollectionUpdateActionInsert
@property (nonatomic, readonly, nullable) NSIndexPath *indexPathAfterUpdate; // nil for UICollectionUpdateActionDelete
@property (nonatomic, readonly) UICollectionUpdateAction updateAction;

@end

```


```
无效的上下文，为什么需要这个？ ， 刷新好像我们经常是没有使用到
UIKIT_EXTERN API_AVAILABLE(ios(7.0)) @interface UICollectionViewLayoutInvalidationContext : NSObject

@property (nonatomic, readonly) BOOL invalidateEverything; //-reloadData 的时候，这个值被设置为YES，表示无效发生 ， 也就是其他的修改不会影响到当前的刷新周期
@property (nonatomic, readonly) BOOL invalidateDataSourceCounts; // 如果是YES， layout必须询问section和counts从collectionView获取； 设置为YES，当-reloadDAta和inseted或者deleted 的时候；

、、 设置无效的三种view
- (void)invalidateItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths API_AVAILABLE(ios(8.0)); 
- (void)invalidateSupplementaryElementsOfKind:(NSString *)elementKind atIndexPaths:(NSArray<NSIndexPath *> *)indexPaths API_AVAILABLE(ios(8.0));
- (void)invalidateDecorationElementsOfKind:(NSString *)elementKind atIndexPaths:(NSArray<NSIndexPath *> *)indexPaths API_AVAILABLE(ios(8.0));

、、 获取三种无效的view
@property (nonatomic, readonly, nullable) NSArray<NSIndexPath *> *invalidatedItemIndexPaths API_AVAILABLE(ios(8.0));
@property (nonatomic, readonly, nullable) NSDictionary<NSString *, NSArray<NSIndexPath *> *> *invalidatedSupplementaryIndexPaths API_AVAILABLE(ios(8.0)); // keys are element kind strings - values are NSArrays of NSIndexPaths
@property (nonatomic, readonly, nullable) NSDictionary<NSString *, NSArray<NSIndexPath *> *> *invalidatedDecorationIndexPaths API_AVAILABLE(ios(8.0)); // keys are element kind strings - values are NSArrays of NSIndexPaths

// cpmtemtPffset 调整的位置
@property (nonatomic) CGPoint contentOffsetAdjustment API_AVAILABLE(ios(8.0)); // delta to be applied to the collection view's current contentOffset - default is CGPointZero
@property (nonatomic) CGSize contentSizeAdjustment API_AVAILABLE(ios(8.0)); // delta to be applied to the current content size - default is CGSizeZero

// 重排的支持
@property (nonatomic, readonly, copy, nullable) NSArray<NSIndexPath *> *previousIndexPathsForInteractivelyMovingItems API_AVAILABLE(ios(9.0)); // index paths of moving items prior to the invalidation
@property (nonatomic, readonly, copy, nullable) NSArray<NSIndexPath *> *targetIndexPathsForInteractivelyMovingItems API_AVAILABLE(ios(9.0)); // index paths of moved items following the invalidation
@property (nonatomic, readonly) CGPoint interactiveMovementTarget API_AVAILABLE(ios(9.0)); // 移动的慕白哦位置

@end


```


```
列表布局 ， 默认是有这些属性
UIKIT_EXTERN API_AVAILABLE(ios(6.0)) @interface UICollectionViewLayout : NSObject <NSCoding>

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

// Methods in this class are meant to be overridden and will be called by its collection view to gather layout information.
// To get the truth on the current state of the collection view, call methods on UICollectionView rather than these.

@property (nullable, nonatomic, readonly) UICollectionView *collectionView;

// Call -invalidateLayout to indicate that the collection view needs to requery the layout information.
// Subclasses must always call super if they override.
- (void)invalidateLayout;
- (void)invalidateLayoutWithContext:(UICollectionViewLayoutInvalidationContext *)context API_AVAILABLE(ios(7.0));

- (void)registerClass:(nullable Class)viewClass forDecorationViewOfKind:(NSString *)elementKind;
- (void)registerNib:(nullable UINib *)nib forDecorationViewOfKind:(NSString *)elementKind;

@end

```

```

@interface UICollectionViewLayout (UISubclassingHooks)
页面布局： 子类继冲洗的时候，可以重写这些方法

@property(class, nonatomic, readonly) Class layoutAttributesClass; // override this method to provide a custom class to be used when instantiating instances of UICollectionViewLayoutAttributes
@property(class, nonatomic, readonly) Class invalidationContextClass API_AVAILABLE(ios(7.0)); // override this method to provide a custom class to be used for invalidation contexts

// The collection view calls -prepareLayout once at its first layout as the first message to the layout instance.
// The collection view calls -prepareLayout again after layout is invalidated and before requerying the layout information.
// Subclasses should always call super if they override.
- (void)prepareLayout;

// UICollectionView calls these four methods to determine the layout information.
// Implement -layoutAttributesForElementsInRect: to return layout attributes for for supplementary or decoration views, or to perform layout in an as-needed-on-screen fashion.
// Additionally, all layout subclasses should implement -layoutAttributesForItemAtIndexPath: to return layout attributes instances on demand for specific index paths.
// If the layout supports any supplementary or decoration view types, it should also implement the respective atIndexPath: methods for those types.
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect; // return an array layout attributes instances for all the views in the given rect
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath;
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath;

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds; // return YES to cause the collection view to requery the layout for geometry information
- (UICollectionViewLayoutInvalidationContext *)invalidationContextForBoundsChange:(CGRect)newBounds API_AVAILABLE(ios(7.0));

- (BOOL)shouldInvalidateLayoutForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes API_AVAILABLE(ios(8.0));
- (UICollectionViewLayoutInvalidationContext *)invalidationContextForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes API_AVAILABLE(ios(8.0));

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity; // return a point at which to rest after scrolling - for layouts that want snap-to-point scrolling behavior
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset API_AVAILABLE(ios(7.0)); // a layout can return the content offset to be applied during transition or update animations

@property(nonatomic, readonly) CGSize collectionViewContentSize; // Subclasses must override this method and use it to return the width and height of the collection view’s content. These values represent the width and height of all the content, not just the content that is currently visible. The collection view uses this information to configure its own content size to facilitate scrolling.

@property (nonatomic, readonly) UIUserInterfaceLayoutDirection developmentLayoutDirection; // Default implementation returns the layout direction of the main bundle's development region; FlowLayout returns leftToRight. Subclasses may override this to specify the implementation-time layout direction of the layout.
@property(nonatomic, readonly) BOOL flipsHorizontallyInOppositeLayoutDirection; // Base implementation returns false. If your subclass’s implementation overrides this property to return true, a UICollectionView showing this layout will ensure its bounds.origin is always found at the leading edge, flipping its coordinate system horizontally if necessary.

@end

```

```
页面布局更新
@interface UICollectionViewLayout (UIUpdateSupportHooks)

// This method is called when there is an update with deletes/inserts to the collection view.
// It will be called prior to calling the initial/final layout attribute methods below to give the layout an opportunity to do batch computations for the insertion and deletion layout attributes.
// The updateItems parameter is an array of UICollectionViewUpdateItem instances for each element that is moving to a new index path.
- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems;
- (void)finalizeCollectionViewUpdates; // called inside an animation block after the update

- (void)prepareForAnimatedBoundsChange:(CGRect)oldBounds; // UICollectionView calls this when its bounds have changed inside an animation block before displaying cells in its new bounds
- (void)finalizeAnimatedBoundsChange; // also called inside the animation block

// UICollectionView calls this when prior the layout transition animation on the incoming and outgoing layout
- (void)prepareForTransitionToLayout:(UICollectionViewLayout *)newLayout API_AVAILABLE(ios(7.0));
- (void)prepareForTransitionFromLayout:(UICollectionViewLayout *)oldLayout API_AVAILABLE(ios(7.0));
- (void)finalizeLayoutTransition API_AVAILABLE(ios(7.0));  // called inside an animation block after the transition


// This set of methods is called when the collection view undergoes an animated transition such as a batch update block or an animated bounds change.
// For each element on screen before the invalidation, finalLayoutAttributesForDisappearingXXX will be called and an animation setup from what is on screen to those final attributes.
// For each element on screen after the invalidation, initialLayoutAttributesForAppearingXXX will be called and an animation setup from those initial attributes to what ends up on screen.
- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath;
- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath;
- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath;
- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath;
- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingDecorationElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)decorationIndexPath;
- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingDecorationElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)decorationIndexPath;

// These methods are called by collection view during an update block.
// Return an array of index paths to indicate views that the layout is deleting or inserting in response to the update.
- (NSArray<NSIndexPath *> *)indexPathsToDeleteForSupplementaryViewOfKind:(NSString *)elementKind API_AVAILABLE(ios(7.0));
- (NSArray<NSIndexPath *> *)indexPathsToDeleteForDecorationViewOfKind:(NSString *)elementKind API_AVAILABLE(ios(7.0));
- (NSArray<NSIndexPath *> *)indexPathsToInsertForSupplementaryViewOfKind:(NSString *)elementKind API_AVAILABLE(ios(7.0));
- (NSArray<NSIndexPath *> *)indexPathsToInsertForDecorationViewOfKind:(NSString *)elementKind API_AVAILABLE(ios(7.0));

@end

```

```
页面布局 ： 重排
@interface UICollectionViewLayout (UIReorderingSupportHooks)

- (NSIndexPath *)targetIndexPathForInteractivelyMovingItem:(NSIndexPath *)previousIndexPath withPosition:(CGPoint)position API_AVAILABLE(ios(9.0));
- (UICollectionViewLayoutAttributes *)layoutAttributesForInteractivelyMovingItemAtIndexPath:(NSIndexPath *)indexPath withTargetPosition:(CGPoint)position API_AVAILABLE(ios(9.0));

- (UICollectionViewLayoutInvalidationContext *)invalidationContextForInteractivelyMovingItems:(NSArray<NSIndexPath *> *)targetIndexPaths withTargetPosition:(CGPoint)targetPosition previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths previousPosition:(CGPoint)previousPosition API_AVAILABLE(ios(9.0));
- (UICollectionViewLayoutInvalidationContext *)invalidationContextForEndingInteractiveMovementOfItemsToFinalIndexPaths:(NSArray<NSIndexPath *> *)indexPaths previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths movementCancelled:(BOOL)movementCancelled API_AVAILABLE(ios(9.0));

@end

```

Decoration
 其实在这里就是糊上一张背景图啥的；

参考链接：
https://zhang759740844.github.io/2017/07/27/UICollectionView%E5%AE%8C%E5%85%A8%E8%A7%A3%E6%9E%90/

使用了额外的太那几的cell的内容，可以定义了定义这些东西，做一个额外的背景啥的；



https://github.com/zhang759740844/MyOCDemo/tree/develop/UICollectionViewDemo 

