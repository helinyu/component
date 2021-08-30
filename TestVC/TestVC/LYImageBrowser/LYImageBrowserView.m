//
//  LYImageBrowserView.m
//  TestVC
//
//  Created by xn on 2021/8/27.
//

#import "LYImageBrowserView.h"
#import "LYImageBrowserBaseCell.h"

@interface LYImageBrowserView ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *list;

@end

@implementation LYImageBrowserView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initBrowserView];
    }
    return self;
}

- (void)initBrowserView {
    UICollectionViewFlowLayout *viewLayout = [UICollectionViewFlowLayout new];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:viewLayout];
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[LYImageBrowserBaseCell class] forCellWithReuseIdentifier:NSStringFromClass([LYImageBrowserBaseCell class])];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
//    这个要看一下扩展的cell， 看一下要不要用这个cell，一直只能够用一种类型的cell
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

#pragma mark -- datasource & delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.datasource && [self.datasource respondsToSelector:@selector(numberOfImageBrowserView:)]) {
        return [self.datasource numberOfImageBrowserView:collectionView];
    }
    return self.list.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LYImageBrowserBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LYImageBrowserBaseCell class]) forIndexPath:indexPath];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.bounds.size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//     这里面要处理是在哪里停止了
}


@end
