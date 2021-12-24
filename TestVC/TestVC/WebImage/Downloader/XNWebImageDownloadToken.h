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

- (void)cancel; // 取消当前的下载

@property (nonatomic, strong, nullable, readonly) NSURL *url; // 下载的URL

@property (nonatomic, strong, nullable, readonly) NSURLRequest *request; // url请求

@property (nonatomic, strong, nullable, readonly) NSURLResponse *response; // url响应

// 统计流量
@property (nonatomic, strong, nullable, readonly) NSURLSessionTaskMetrics *metrics API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

@end

NS_ASSUME_NONNULL_END
