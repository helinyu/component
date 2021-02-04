// SDWebImageDownloaderRequestModifier 请求的修改， 这个看看有什么属性， 这些属性不是很重要， 主要是修改下载的配置

#import <Foundation/Foundation.h>
#import "SDWebImageCompat.h"

typedef NSURLRequest * _Nullable (^SDWebImageDownloaderRequestModifierBlock)(NSURLRequest * _Nonnull request);
@protocol SDWebImageDownloaderRequestModifier <NSObject>
- (nullable NSURLRequest *)modifiedRequestWithRequest:(nonnull NSURLRequest *)request;

@end

@interface SDWebImageDownloaderRequestModifier : NSObject <SDWebImageDownloaderRequestModifier>

//  配置的一个简单的修改器
- (nonnull instancetype)initWithBlock:(nonnull SDWebImageDownloaderRequestModifierBlock)block;
+ (nonnull instancetype)requestModifierWithBlock:(nonnull SDWebImageDownloaderRequestModifierBlock)block;

@end

//  遍历的方式的修改器
@interface SDWebImageDownloaderRequestModifier (Conveniences)

- (nonnull instancetype)initWithMethod:(nullable NSString *)method;
- (nonnull instancetype)initWithHeaders:(nullable NSDictionary<NSString *, NSString *> *)headers;
- (nonnull instancetype)initWithBody:(nullable NSData *)body;
- (nonnull instancetype)initWithMethod:(nullable NSString *)method headers:(nullable NSDictionary<NSString *, NSString *> *)headers body:(nullable NSData *)body;

@end



@interface SDWebImageDownloaderRequestModifier ()

@property (nonatomic, copy, nonnull) SDWebImageDownloaderRequestModifierBlock block;

@end

@implementation SDWebImageDownloaderRequestModifier

- (instancetype)initWithBlock:(SDWebImageDownloaderRequestModifierBlock)block {
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

+ (instancetype)requestModifierWithBlock:(SDWebImageDownloaderRequestModifierBlock)block {
    SDWebImageDownloaderRequestModifier *requestModifier = [[SDWebImageDownloaderRequestModifier alloc] initWithBlock:block];
    return requestModifier;
}

- (NSURLRequest *)modifiedRequestWithRequest:(NSURLRequest *)request {
    if (!self.block) {
        return nil;
    }
    return self.block(request);
}

@end

@implementation SDWebImageDownloaderRequestModifier (Conveniences)

- (instancetype)initWithMethod:(NSString *)method {
    return [self initWithMethod:method headers:nil body:nil];
}

- (instancetype)initWithHeaders:(NSDictionary<NSString *,NSString *> *)headers {
    return [self initWithMethod:nil headers:headers body:nil];
}

- (instancetype)initWithBody:(NSData *)body {
    return [self initWithMethod:nil headers:nil body:body];
}

- (instancetype)initWithMethod:(NSString *)method headers:(NSDictionary<NSString *,NSString *> *)headers body:(NSData *)body {
    method = method ? [method copy] : @"GET";
    headers = [headers copy];
    body = [body copy];
    return [self initWithBlock:^NSURLRequest * _Nullable(NSURLRequest * _Nonnull request) {
        NSMutableURLRequest *mutableRequest = [request mutableCopy];
        mutableRequest.HTTPMethod = method;
        mutableRequest.HTTPBody = body;
        for (NSString *header in headers) {
            NSString *value = headers[header];
            [mutableRequest setValue:value forHTTPHeaderField:header];
        }
        return [mutableRequest copy];
    }];
}

@end
