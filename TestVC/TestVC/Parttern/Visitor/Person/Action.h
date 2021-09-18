//
//  Action.h
//  TestVC
//
//  Created by xn on 2021/9/8.
//

#import <Foundation/Foundation.h>

@protocol Person;

NS_ASSUME_NONNULL_BEGIN

@protocol Action <NSObject>

@property (nonatomic, copy) NSString *name;

- (void)getMainConclusion:(id<Person>)man;
- (void)getWomanConclusion:(id<Person>)woman;

@end

NS_ASSUME_NONNULL_END
