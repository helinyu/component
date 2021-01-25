
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

