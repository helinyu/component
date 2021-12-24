//
//  SDWebImageDownloader.h
//  TestVC
//
//  Created by xn on 2021/12/23.
//

#import <Foundation/Foundation.h>
#import "XNWebImageDownloaderConfig.h"
#import "XNWebImageDownloaderRequestModifier.h"
#import "XNWebImageDownloaderResponseModifier.h"
#import "XNWebImageDownloaderDecryptor.h"
#import "XNWebImageDownloaderDefine.h"
#import "XNWebImageDownloadToken.h"
#import "XNImageLoader.h"
#import "XNWebImageDefine.h"

NS_ASSUME_NONNULL_BEGIN

// 图片的下载和优化
@interface XNWebImageDownloader : NSObject

// 支持动态配置 存储所有的设置
@property (nonatomic, copy, readonly, nonnull) XNWebImageDownloaderConfig *config;

// 默认是nil，灭有修改不，如果只是建档的修改，可以考虑使用SDWebImageDownloaderRequestModifier
// 在请求之前修改请求参数， 对于每个请求都是会掉员工的额
@property (nonatomic, strong, nullable) id<XNWebImageDownloaderRequestModifier> requestModifier;

// 对origin response 进行修改
@property (nonatomic, strong, nullable) id<XNWebImageDownloaderResponseModifier> responseModifier;

// 解密器
// 数据解码之前就要解密
@property (nonatomic, strong, nullable) id<XNWebImageDownloaderDecryptor> decryptor; // 解码器

@property (nonatomic, readonly, nonnull) NSURLSessionConfiguration *sessionconfiguration; // 会话配置

// 下载悬挂状态
@property (nonatomic, assign, getter=isSuspended) BOOL suspended;

@property (nonatomic, assign, readonly) NSUInteger currentDownloadCount; // 显示当前下载的数目

@property (nonatomic, class, readonly, nonnull) XNWebImageDownloader *sharedDownloader; //下载器

- (nonnull instancetype)initWithConfig:(nullable XNWebImageDownloaderConfig *)config NS_DESIGNATED_INITIALIZER;

// 头部的field设置
- (void)setValue:(nullable NSString *)value forHTTPHeaderField:(nullable NSString *)field; //有关的设置内容
- (nullable NSString *)valueForHTTPHeaderField:(nullable NSString *)field;

// 下载的方法

- (nullable XNWebImageDownloadToken *)downloadImageWithURL:(nullable NSURL *)url
                                                 completed:(nullable XNWebImageDownloaderCompletedBlock)completedBlock;

- (nullable XNWebImageDownloadToken *)downloadImageWithURL:(nullable NSURL *)url
                                                   options:(XNWebImageDownloaderOptions)options
                                                  progress:(nullable XNWebImageDownloaderProgressBlock)progressBlock
                                                 completed:(nullable XNWebImageDownloaderCompletedBlock)completedBlock;

- (nullable XNWebImageDownloadToken *)downloadImageWithURL:(nullable NSURL *)url
                                                   options:(XNWebImageDownloaderOptions)options
                                                   context:(nullable XNWebImageContext *)context
                                                  progress:(nullable XNWebImageDownloaderProgressBlock)progressBlock
                                                 completed:(nullable XNWebImageDownloaderCompletedBlock)completedBlock;

- (void)cancelAllDownloads; // 取消所有的下载
- (void)invalidateSessionAndCancel:(BOOL)cancelPendingOperations; // 无效或取消

@end

@interface XNWebImageDownloader (XNImageLoader) <XNImageLoader>

@end


NS_ASSUME_NONNULL_END
