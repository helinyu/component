//
//  Person.h
//  TestVC
//
//  Created by xn on 2021/9/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol Action;

@protocol Person <NSObject>

@property (nonatomic, copy) NSString *name;
- (void)accept:(id<Action>)visitor;

@end

NS_ASSUME_NONNULL_END
