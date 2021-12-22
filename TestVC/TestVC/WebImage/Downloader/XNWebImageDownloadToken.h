//
//  SDWebImageDownloadToken.h
//  TestVC
//
//  Created by xn on 2021/12/22.
//

#import <Foundation/Foundation.h>
#import "XNWebImageOperation.h"

NS_ASSUME_NONNULL_BEGIN

@interface XNWebImageDownloadToken : NSObject <XNWebImageOperation>

@property (nonatomic, strong, nullable) NSURL *url;

/**
 The cancel token taken from `addHandlersForProgress:completed`. This should be readonly and you should not modify
 @note use `-[SDWebImageDownloadToken cancel]` to cancel the token
 */
// addHandlersForProgress 获得的token
// 一个下载，就对应一个token，token包括了什么？ url、cancel。downloadOpertion
@property (nonatomic, strong, nullable) id downloadOperationCancelToken;

@end

NS_ASSUME_NONNULL_END
