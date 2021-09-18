//
//  ObjectStructure.h
//  TestVC
//
//  Created by xn on 2021/9/8.
//

#import <Foundation/Foundation.h>

@protocol Action;

NS_ASSUME_NONNULL_BEGIN

@interface ObjectStructure : NSObject

@property (nonatomic, strong) NSMutableArray *arr;
- (void)display:(id<Action>)visitor;

@end

NS_ASSUME_NONNULL_END
