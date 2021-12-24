//
//  XNWebImageDownloaderConfig.h
//  TestVC
//
//  Created by xn on 2021/12/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/// Operation execution order
typedef NS_ENUM(NSInteger, XNWebImageDownloaderExecutionOrder) {
    // 先进先出
    XNWebImageDownloaderFIFOExecutionOrder,
    
    // 后进先出
    XNWebImageDownloaderLIFOExecutionOrder
};


@interface XNWebImageDownloaderConfig : NSObject<NSCopying>

@property (nonatomic, class, readonly, nonnull) XNWebImageDownloaderConfig *defaultDownloaderConfig;

// 默认是6，并行下载
@property (nonatomic, assign) NSInteger maxConcurrentDownloads;

// 默认 15.0 , 对于每个下载的超时时间
@property (nonatomic, assign) NSTimeInterval downloadTimeout;

// 0.0-1.0. 就是进度回调的间隔时间
@property (nonatomic, assign) double minimumProgressInterval;

// 默认是nil，自定义配置的sessionconfig, 没有就使用defaultSessionConfiguration ，不可以动态改变
@property (nonatomic, strong, nullable) NSURLSessionConfiguration *sessionConfiguration; // 配置

/**
 * Gets/Sets a subclass of `SDWebImageDownloaderOperation` as the default
 * `NSOperation` to be used each time SDWebImage constructs a request
 * operation to download an image.
 * Defaults to nil.
 * @note Passing `NSOperation<SDWebImageDownloaderOperation>` to set as default. Passing `nil` will revert to `SDWebImageDownloaderOperation`.
 */
@property (nonatomic, assign, nullable) Class operationClass;

@property (nonatomic, assign) XNWebImageDownloaderExecutionOrder executionOrder; // 默认：先进先出

// 验证
@property (nonatomic, copy, nullable) NSURLCredential *urlCredential;

@property (nonatomic, copy, nullable) NSString *username;
@property (nonatomic, copy, nullable) NSString *password;

// Defaults to [200,400). Nil means no validation at all.
// 默认：如果返回503 就会报错
@property (nonatomic, copy, nullable) NSIndexSet *acceptableStatusCodes;

// 设置接收的类型，如果不一样，就报错， 默认是nil，表示所有的类型都接受
// eg：["image/png"] 如果返回"application/json" 会报错。
@property (nonatomic, copy, nullable) NSSet<NSString *> *acceptableContentTypes;

@end

NS_ASSUME_NONNULL_END
