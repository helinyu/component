//
//  XNWebImageDownloaderDefine.h
//  TestVC
//
//  Created by xn on 2021/12/23.
//

#ifndef XNWebImageDownloaderDefine_h
#define XNWebImageDownloaderDefine_h

#import "XNWebImageLoaderDefine.h"


/// Downloader options
typedef NS_OPTIONS(NSUInteger, XNWebImageDownloaderOptions) {
    
    // 低队列任务
    XNWebImageDownloaderLowPriority = 1 << 0,
    
    // 进度渐进下载
    XNWebImageDownloaderProgressiveLoad = 1 << 1,

//    *URLCache 设置，默认是没有的
    XNWebImageDownloaderUseNSURLCache = 1 << 2,

    /**
     * Call completion block with nil image/imageData if the image was read from NSURLCache
     * And the error code is `XNWebImageErrorCacheNotModified`
     * This flag should be combined with `XNWebImageDownloaderUseNSURLCache`.
     */
//   从NSURLCache读取数据 ， 需要和XNWebImageDownloaderUseNSURLCache 一起使用
    XNWebImageDownloaderIgnoreCachedResponse = 1 << 3,
    
//    * 是否在号后台继续下载
    XNWebImageDownloaderContinueInBackground = 1 << 4,

//    *NSMutableURLRequest.HTTPShouldHandleCookies = YES;
    XNWebImageDownloaderHandleCookies = 1 << 5,

    //    * SLL验证设置
    XNWebImageDownloaderAllowInvalidSSLCertificates = 1 << 6,

    //    *高优先级队列
    XNWebImageDownloaderHighPriority = 1 << 7,
    
//    * 缩放大图图片
    XNWebImageDownloaderScaleDownLargeImages = 1 << 8,

//    拒接解码， 因为CPU在后台解码可以节省渲染， 但是同时消耗内存
    XNWebImageDownloaderAvoidDecodeImage = 1 << 9,
    
//    * animated image 解码第一张图片
    XNWebImageDownloaderDecodeFirstFrameOnly = 1 << 10,
    
//    *预加载所有的帧 preloadAllAnimatedImageFrames = YES
    XNWebImageDownloaderPreloadAllFrames = 1 << 11,
    
    /**
     * By default, when you use `XNWebImageContextAnimatedImageClass` context option (like using `SDAnimatedImageView` which designed to use `SDAnimatedImage`), we may still use `UIImage` when the memory cache hit, or image decoder is not available, to behave as a fallback solution.
     * Using this option, can ensure we always produce image with your provided class. If failed, a error with code `XNWebImageErrorBadImageData` will been used.
     * Note this options is not compatible with `XNWebImageDownloaderDecodeFirstFrameOnly`, which always produce a UIImage/NSImage.
     */
    // 匹配对应的动态图片
    XNWebImageDownloaderMatchAnimatedImageClass = 1 << 12,
};

// 下载开始通知
FOUNDATION_EXPORT NSNotificationName _Nonnull const XNWebImageDownloadStartNotification;

// 接收响应通知
FOUNDATION_EXPORT NSNotificationName _Nonnull const XNWebImageDownloadReceiveResponseNotification;

// 下载停止通知
FOUNDATION_EXPORT NSNotificationName _Nonnull const XNWebImageDownloadStopNotification;

//下载完成通知
FOUNDATION_EXPORT NSNotificationName _Nonnull const XNWebImageDownloadFinishNotification;

// 下载进度的block
typedef XNImageLoaderProgressBlock XNWebImageDownloaderProgressBlock;

// 下载完成的block
typedef XNImageLoaderCompletedBlock XNWebImageDownloaderCompletedBlock;


// 下载4个状态的通知
NSNotificationName const XNWebImageDownloadStartNotification = @"XNWebImageDownloadStartNotification";
NSNotificationName const XNWebImageDownloadReceiveResponseNotification = @"XNWebImageDownloadReceiveResponseNotification";
NSNotificationName const XNWebImageDownloadStopNotification = @"XNWebImageDownloadStopNotification";
NSNotificationName const XNWebImageDownloadFinishNotification = @"XNWebImageDownloadFinishNotification";

#endif /* XNWebImageDownloaderDefine_h */
