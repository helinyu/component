//
//  XNWebImageDownloaderRequestModifier.h
//  TestVC
//
//  Created by xn on 2021/12/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


// NSURLProtocol 这个协议，也是修改这个url的内容，这个是指在前面做了一个拦截
// 是不一样的概念

typedef NSURLRequest * _Nullable (^XNWebImageDownloaderRequestModifierBlock)(NSURLRequest * _Nonnull request);


@protocol XNWebImageDownloaderRequestModifier <NSObject>

/// Modify the original URL request and return a new one instead. You can modify the HTTP header, cachePolicy, etc for this URL.
- (nullable NSURLRequest *)modifiedRequestWithRequest:(nonnull NSURLRequest *)request;

@end


@interface XNWebImageDownloaderRequestModifier : NSObject<XNWebImageDownloaderRequestModifier>

- (nonnull instancetype)initWithBlock:(nonnull XNWebImageDownloaderRequestModifierBlock)block;

+ (nonnull instancetype)requestModifierWithBlock:(nonnull XNWebImageDownloaderRequestModifierBlock)block;

@end


@interface XNWebImageDownloaderRequestModifier (Conveniences)

// http方法，nil意味是GET
- (nonnull instancetype)initWithMethod:(nullable NSString *)method;

// 替换headers
- (nonnull instancetype)initWithHeaders:(nullable NSDictionary<NSString *, NSString *> *)headers;

/// http body的内容
- (nonnull instancetype)initWithBody:(nullable NSData *)body;

/// 集合的内容配置
- (nonnull instancetype)initWithMethod:(nullable NSString *)method headers:(nullable NSDictionary<NSString *, NSString *> *)headers body:(nullable NSData *)body;

@end

NS_ASSUME_NONNULL_END
