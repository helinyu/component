//
//  TestCollectionViewCell.m
//  TestVC
//
//  Created by xn on 2021/5/27.
//

#import "TestCollectionViewCell.h"

@implementation TestCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

@end
