//
//  MyWorkerClass.h
//  TestVC
//
//  Created by xn on 2021/9/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyWorkerClass : NSObject

- (void)launchThreadWithPort:(NSPort *)port;

@end

NS_ASSUME_NONNULL_END
