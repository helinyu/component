//
//  XMGHorizontalFlexbleLayout.h
//  XZBaseProject
//
//  Created by helinyu on 2021/1/21.
//  Copyright © 2021 FoShan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XMGHorizontalFlexbleLayoutDelegate <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView showHeight:(CGFloat)showHeight;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface XMGHorizontalFlexbleLayout : UICollectionViewLayout

@property (nonatomic, assign) CGFloat miniItemSpace; // 左右两边的间距
@property (nonatomic, assign) CGFloat miniLineSpace; // 上下两行的的间距
@property (nonatomic, assign) NSInteger maxLineNum; // 最多可以显示多少行， 如果是0 的话， 就是可以显示无限的行数

@end

NS_ASSUME_NONNULL_END
