//
//  XMGHorizontalFlexbleLayout.m
//  XZBaseProject
//
//  Created by helinyu on 2021/1/21.
//  Copyright © 2021 FoShan. All rights reserved.
//

#import "XMGHorizontalFlexbleLayout.h"

@interface XMGHorizontalFlexbleLayout ()

@property (nonatomic, weak) id<XMGHorizontalFlexbleLayoutDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *attrsArray; // 富文本的数组
@property (nonatomic, assign) CGFloat lastShowToY; // 显示开始的Y值， 暂时没有包括间距
@property (nonatomic, assign) CGFloat lastShowToX; // 显示开始的X值, 暂时没有包括间距
@property (nonatomic, assign) NSInteger showLineIndex; // 显示的行索引， 从0开始

@property (nonatomic, assign) CGFloat showToLargeY; // 显示的所有的内容之后的底部的Y值
@property (nonatomic, assign) NSArray<NSString *> *tagTexts; // 显示tag文本的内容

@end

@implementation XMGHorizontalFlexbleLayout

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [[NSMutableArray alloc] init];
    }
    return _attrsArray;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}


- (NSInteger)maxLineNum {
    if (_maxLineNum > 0) {
        return _maxLineNum;
    }
    return NSIntegerMax;
}
// 先计算准备内容
- (void)prepareLayout
{
    [super prepareLayout];

    self.delegate = (id)self.collectionView.delegate;
    
    [self.attrsArray removeAllObjects];
    self.lastShowToY = 0.f;
    self.lastShowToX = 0.f;
    self.showLineIndex = 0;
    NSInteger count = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    if (count <=0) return;
    
    for (NSInteger index =0; index < count; index++) {
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        if (self.showLineIndex >= self.maxLineNum) {
            break;
        }
        [self.attrsArray addSafeObject:attrs];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:showHeight:)]) {
        [self.delegate collectionView:self.collectionView showHeight:self.showToLargeY];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (!self.delegate || ![self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        return nil;
    }
    CGSize size =[self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    CGFloat collectionWidth = self.collectionView.frame.size.width;
    CGFloat tagWidth = MIN(size.width, collectionWidth);
    CGFloat tagHeight = size.height;

    CGFloat originX = indexPath.item ==0? CGFLOAT_MIN : self.lastShowToX + self.miniItemSpace; // 左边的位置
    CGFloat toLargeWidth = originX + tagWidth; // 右边的位置
    if (toLargeWidth > collectionWidth) { // 换行
        originX = 0.f;
        toLargeWidth = originX + tagWidth;
        self.lastShowToY += (tagHeight + self.miniLineSpace);
        self.showLineIndex +=1;
    }
    self.lastShowToX = toLargeWidth;
    self.showToLargeY = (self.lastShowToY + tagHeight);
                       
    CGRect frame = CGRectMake(originX, self.lastShowToY, tagWidth, tagHeight);

    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = frame;
    
    return attrs;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width, self.showToLargeY);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *layoutAttris = [[NSMutableArray alloc] init];
    for (UICollectionViewLayoutAttributes *attri in self.attrsArray) {
        if (CGRectIntersectsRect(rect, attri.frame)) {
            [layoutAttris addObject:attri];
        }
    }
    return layoutAttris;
}

@end
