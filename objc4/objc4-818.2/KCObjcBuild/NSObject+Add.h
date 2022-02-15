//
//  NSObject+Add.h
//  KCObjcBuild
//
//  Created by xn on 2022/2/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XNTestProtocol <NSObject>


@end

@interface NSObject (Add)<XNTestProtocol>

@end

NS_ASSUME_NONNULL_END
