//
//  SDWebImageDownloaderOperationInterface.h
//  TestVC
//
//  Created by xn on 2021/12/22.
//

#import <Foundation/Foundation.h>
#import "XNWebImageDownloaderOptionsFile.h"
#import "XNWebImageDownloaderBlockFile.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XNWebImageDownloaderOperationInterface <NSObject>

@required

// 初始化
- (instancetype)initWithReqeust:(nullable NSURLRequest *)request
                        inSession:(nullable NSURLSession *)session
                        options:(XNWebImageDownloaderOptions)opptions;

// 添加处理
- (nullable id)addHandlersForProgress:(nullable XNWebImageDownloaderProgressBlock)progressBlock
                            completed:(nullable XNWebImageDownloaderCompletedBlock)completedBlock;

// 是否解压图片
- (BOOL)shouldDecompressImages;
- (void)setShouldDecompressImages:(BOOL)value;

- (nullable NSURLCredential *)credential; // 获取
- (void)setCredential:(nullable NSURLCredential *)value; // 设置url的信任

- (BOOL)cancel:(nullable id)token; // 取消这个token

@optional
- (nullable NSURLSessionTask *)dataTask; // 看一下当前的这个任务

@end

NS_ASSUME_NONNULL_END
