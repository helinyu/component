//
//  KMCollectionViewWaterLayout.m
//  xndm_proj
//
//  Created by Linfeng Song on 2020/9/10.
//  Copyright © 2020 Linfeng Song. All rights reserved.
//

#import "KMCollectionViewWaterLayout.h"

@interface KMCollectionViewWaterLayout ()
@property (nonatomic, weak) id<KMUICollectionViewDelegateWaterLayout> delegate;

/** 这个字典用来存储每一列最大的Y值(每一列的高度) */
@property (nonatomic, strong) NSMutableArray *maxYArray;

/** 存放所有的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;

@property (nonatomic, assign) CGFloat maxY;

@end


@implementation KMCollectionViewWaterLayout


- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [[NSMutableArray alloc] init];
    }
    return _attrsArray;
}

- (NSMutableArray *)maxYArray
{
    if (!_maxYArray) {
        _maxYArray = [[NSMutableArray alloc] init];
    }
    return _maxYArray;
}


- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

/**
 *  每次布局之前的准备
 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    self.delegate = (id)self.collectionView.delegate;
    
    //清空数据数据
    [self.maxYArray removeAllObjects];
    [self.attrsArray removeAllObjects];
    
    self.maxY = 0;
    NSInteger sectionCnt = [self.collectionView numberOfSections];
    
    for (NSInteger section=0; section < sectionCnt; section++) {
        
        UIEdgeInsets sectionInset = self.sectionInset;
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
            sectionInset = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
        }
        
        //头部
        UICollectionViewLayoutAttributes *headerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        if (headerAttrs) {
            [self.attrsArray addObject:headerAttrs];
        }
        
        self.maxY += sectionInset.top;
        
        //cell
        NSInteger columnsCount = self.columnsCount;
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:columnsCountForSectionAtIndex:)]) {
            columnsCount = [self.delegate collectionView:self.collectionView layout:self columnsCountForSectionAtIndex:section];
        }
        
        NSMutableDictionary *maxYdict = nil;
        if (self.maxYArray.count > section) {
            maxYdict = [self.maxYArray objectAtIndex:section];
        }
        else{
            maxYdict = [NSMutableDictionary dictionaryWithCapacity:0];
            for (int i = 0; i<columnsCount; i++) {
                NSString *column = [NSString stringWithFormat:@"%d", i];
                maxYdict[column] = @(self.maxY);
            }
            [self.maxYArray addObject:maxYdict];
        }
        
        NSInteger count = [self.collectionView numberOfItemsInSection:section];
        for (int i = 0; i<count; i++) {
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
            [self.attrsArray addObject:attrs];
        }
        
        //计算当前section中的最高值
        __block NSString *maxColumn = @"0";
        [maxYdict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL *stop) {
            if ([maxY floatValue] > [maxYdict[maxColumn] floatValue]) {
                maxColumn = column;
            }
        }];
        self.maxY = [maxYdict[maxColumn] floatValue];
        
        self.maxY += sectionInset.bottom;
        
        //尾部
        UICollectionViewLayoutAttributes *FooterAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        if (FooterAttrs) {
            [self.attrsArray addObject:FooterAttrs];
        }
        
    }
}

/**
 *  返回所有的尺寸
 */
- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width, self.maxY);
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    
    UIEdgeInsets sectionInset = self.sectionInset;
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        sectionInset = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:indexPath.section];
    }
    
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        CGSize headerSize = self.headerReferenceSize;
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            headerSize = [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:indexPath.section];
        }

        // 计算位置
        CGFloat x = 0.0f;
        CGFloat y = _maxY;

        // 更新这一列的最大Y值
        _maxY = y + headerSize.height;
        if (CGSizeEqualToSize(headerSize, CGSizeZero)) {
            return nil;
        }

        // 创建属性
        UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
        attrs.frame = CGRectMake(x, y, headerSize.width, headerSize.height);
        return attrs;
        
    }
    else if([elementKind isEqualToString:UICollectionElementKindSectionFooter])
    {
        CGSize footerSize = self.footerReferenceSize;
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
            footerSize = [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:indexPath.section];
        }

        // 计算位置
        CGFloat x = 0.0f;
        CGFloat y = _maxY;

        // 更新这一列的最大Y值
        _maxY = y + footerSize.height;
        
        if (CGSizeEqualToSize(footerSize, CGSizeZero)) {
            return nil;
        }

        // 创建属性
        UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
        attrs.frame = CGRectMake(x, y, footerSize.width, footerSize.height);
        return attrs;
    }
    
    return nil;
}



/**
 *  返回indexPath这个位置Item的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 假设最短的那一列的第0列
    __block NSString *minColumn = @"0";
    NSMutableDictionary *maxYDict = [self.maxYArray objectAtIndex:indexPath.section];
    // 找出最短的那一列
    [maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] < [maxYDict[minColumn] floatValue]) {
            minColumn = column;
        }
    }];
    
    CGSize cellSize = self.itemSize;
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        cellSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    }
    
    UIEdgeInsets sectionInset = self.sectionInset;
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        sectionInset = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:indexPath.section];
    }
    
    CGFloat lineSpacing = self.lineSpacing;
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        lineSpacing = [self.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:indexPath.section];
    }
    
    CGFloat interitemSpacing = self.interitemSpacing;
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        lineSpacing = [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:indexPath.section];
    }
    
    NSInteger columnsCount = self.columnsCount;
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:columnsCountForSectionAtIndex:)]) {
        columnsCount = [self.delegate collectionView:self.collectionView layout:self columnsCountForSectionAtIndex:indexPath.section];
    }
    
    if (columnsCount > 1) {
        NSInteger _interitemSpacing = (self.collectionView.frame.size.width - sectionInset.left - sectionInset.right - (columnsCount * cellSize.width)) / (columnsCount - 1);
        interitemSpacing = MAX(_interitemSpacing, interitemSpacing);
    }

    // 计算位置
    CGFloat x = sectionInset.left + (cellSize.width + interitemSpacing) * [minColumn intValue];
    CGFloat y = [maxYDict[minColumn] floatValue];
    if (indexPath.item >= columnsCount) { //最顶上元素，不加lineSpacing
        y += lineSpacing;
    }

    // 更新这一列的最大Y值
    maxYDict[minColumn] = @(y + cellSize.height);

    // 创建属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = CGRectMake(x, y, cellSize.width, cellSize.height);
    return attrs;
}

/**
 *  返回rect范围内的布局属性
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
  //  return self.attrsArray;
    NSMutableArray *layoutAttris = [[NSMutableArray alloc] init];
    for (UICollectionViewLayoutAttributes *attri in self.attrsArray) {
        if (CGRectIntersectsRect(rect, attri.frame)) {
            [layoutAttris addObject:attri];
        }
    }
    return layoutAttris;
}

@end
