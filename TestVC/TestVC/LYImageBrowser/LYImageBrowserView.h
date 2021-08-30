//
//  LYImageBrowserView.h
//  TestVC
//
//  Created by xn on 2021/8/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LYImageBrowserView;


typedef void(^RegisterCellsBlock)(NSArray * cells);


@protocol LYImageBrowserViewDatasource <NSObject>

- (NSInteger)numberOfImageBrowserView:(LYImageBrowserView *)view;
- (id)valueForImageBrowserView:(LYImageBrowserView *)view index:(NSInteger)index;

@end

@protocol LYImageBrowserViewDelegate <NSObject>

- (void)imageBrowserView:(LYImageBrowserView *)view scrollAtIndex:(NSInteger)index;

@end

@interface LYImageBrowserView : UIView

@property (nonatomic, weak) id<LYImageBrowserViewDatasource> datasource;
@property (nonatomic, weak) id<LYImageBrowserViewDelegate> delegate;
@property (nonatomic, copy) RegisterCellsBlock registerCellsBlock;

@end

NS_ASSUME_NONNULL_END
