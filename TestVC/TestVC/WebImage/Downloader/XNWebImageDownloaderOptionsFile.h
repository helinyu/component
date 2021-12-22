//
//  XNWebImageDownloaderOptionsFile.h
//  TestVC
//
//  Created by xn on 2021/12/22.
//

#ifndef XNWebImageDownloaderOptionsFile_h
#define XNWebImageDownloaderOptionsFile_h



typedef NS_OPTIONS(NSUInteger, XNWebImageDownloaderOptions) {

    // 将下载任务放在最低的队列中
    SDWebImageDownloaderLowPriority = 1 << 0,

    // 可以进度扩展式下载
    SDWebImageDownloaderProgressiveDownload = 1 << 1,

    //  默认是阻止URLCache的，
    SDWebImageDownloaderUseNSURLCache = 1 << 2,

    // 忽略掉缓存的响应
    SDWebImageDownloaderIgnoreCachedResponse = 1 << 3,
    
    // 是否在后台还会下载数据
    SDWebImageDownloaderContinueInBackground = 1 << 4,

    //  是否处理cookies NSMutableURLRequest.HTTPShouldHandleCookies = YES;
    SDWebImageDownloaderHandleCookies = 1 << 5,

    // 是否SSL信任
    SDWebImageDownloaderAllowInvalidSSLCertificates = 1 << 6,

    //  高优先级队列处理任务
    SDWebImageDownloaderHighPriority = 1 << 7,

    //  是否缩放图片适配scale
    SDWebImageDownloaderScaleDownLargeImages = 1 << 8,
};

typedef NS_ENUM(NSInteger, XNWebImageDownloaderExecutionOrder) {
// 先进先出
    SDWebImageDownloaderFIFOExecutionOrder,

//  后进先出
    SDWebImageDownloaderLIFOExecutionOrder
};

#endif /* XNWebImageDownloaderOptionsFile_h */
