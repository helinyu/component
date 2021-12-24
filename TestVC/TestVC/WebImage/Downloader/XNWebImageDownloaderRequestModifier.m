//
//  XNWebImageDownloaderRequestModifier.m
//  TestVC
//
//  Created by xn on 2021/12/23.
//

#import "XNWebImageDownloaderRequestModifier.h"

@interface XNWebImageDownloaderRequestModifier ()

@property (nonatomic, copy, nonnull) XNWebImageDownloaderRequestModifierBlock block;

@end

@implementation XNWebImageDownloaderRequestModifier

- (instancetype)initWithBlock:(XNWebImageDownloaderRequestModifierBlock)block {
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

+ (instancetype)requestModifierWithBlock:(XNWebImageDownloaderRequestModifierBlock)block {
    XNWebImageDownloaderRequestModifier *requestModifier = [[XNWebImageDownloaderRequestModifier alloc] initWithBlock:block];
    return requestModifier;
}

- (NSURLRequest *)modifiedRequestWithRequest:(NSURLRequest *)request {
    if (!self.block) {
        return nil;
    }
    return self.block(request);
}

@end

@implementation XNWebImageDownloaderRequestModifier (Conveniences)

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
    method  = method? [method copy] : @"GET";
    headers = [headers copy];
    body = [body copy];
    return [self initWithBlock:^NSURLRequest * _Nullable(NSURLRequest * _Nonnull request) {
        NSMutableURLRequest *mutableRequest = [request mutableCopy];
        mutableRequest.HTTPMethod = method;
        mutableRequest.HTTPBody = body;
        for (NSString *header in headers) {
            NSString *value = headers[header];
            [mutableRequest setValue:value forKey:header];
        }
        return [mutableRequest copy];
    }];
}

@end
