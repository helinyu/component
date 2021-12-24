//
//  SDWebImageDownloaderOperationInterface.h
//  TestVC
//
//  Created by xn on 2021/12/22.
//

#import <Foundation/Foundation.h>
#import "XNWebImageDownloaderDefine.h"
#import "XNWebImageDefine.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XNWebImageDownloaderOperation <NSObject>

@required

// 初始化
- (instancetype)initWithReqeust:(nullable NSURLRequest *)request
                        inSession:(nullable NSURLSession *)session
                        options:(XNWebImageDownloaderOptions)opptions;

- (instancetype)initWithReqeust:(nullable NSURLRequest *)request
                        inSession:(nullable NSURLSession *)session
                        options:(XNWebImageDownloaderOptions)opptions
                        context:(nullable XNWebImageContext *)context;;

// 添加处理
- (nullable id)addHandlersForProgress:(nullable XNWebImageDownloaderProgressBlock)progressBlock
                            completed:(nullable XNWebImageDownloaderCompletedBlock)completedBlock;

- (BOOL)cancel:(nullable id)token; // 取消这个token

@property (strong, nonatomic, readonly, nullable) NSURLRequest *request;
@property (strong, nonatomic, readonly, nullable) NSURLResponse *response;

@optional
@property (strong, nonatomic, readonly, nullable) NSURLSessionTask *dataTask;
@property (strong, nonatomic, readonly, nullable) NSURLSessionTaskMetrics *metrics API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

// These operation-level config was inherited from downloader. See `XNDWebImageDownloaderConfig` for documentation.
@property (strong, nonatomic, nullable) NSURLCredential *credential;
@property (assign, nonatomic) double minimumProgressInterval;
@property (copy, nonatomic, nullable) NSIndexSet *acceptableStatusCodes;
@property (copy, nonatomic, nullable) NSSet<NSString *> *acceptableContentTypes;

@end

NS_ASSUME_NONNULL_END
