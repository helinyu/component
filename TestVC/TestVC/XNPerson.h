//
//  XNPerson.h
//  TestVC
//
//  Created by xn on 2021/8/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XNPerson : NSObject<NSCopying>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;

@end

NS_ASSUME_NONNULL_END
