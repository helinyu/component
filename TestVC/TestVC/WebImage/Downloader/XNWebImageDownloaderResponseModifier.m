//
//  XNWebImageDownloaderResponseModifier.m
//  TestVC
//
//  Created by xn on 2021/12/23.
//

#import "XNWebImageDownloaderResponseModifier.h"

@interface XNWebImageDownloaderResponseModifier ()

@property (nonatomic, copy, nonnull) XNWebImageDownloaderResponseModifierBlock block;

@end

@implementation XNWebImageDownloaderResponseModifier

- (nullable NSURLResponse *)modifiedResponseWithResponse:(nonnull NSURLResponse *)response {
    return self.block? self.block(response):nil;
}

- (instancetype)initWithBlock:(XNWebImageDownloaderResponseModifierBlock)block {
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

+ (instancetype)responseWithModifierWithBlock:(XNWebImageDownloaderResponseModifierBlock)block{
    XNWebImageDownloaderResponseModifier *responseModifier = [[XNWebImageDownloaderResponseModifier alloc] initWithBlock:block];
    return responseModifier;
}

@end

@implementation XNWebImageDownloaderResponseModifier (Conveniences)

- (instancetype)initWithStatusCode:(NSInteger)statusCode {
    return [self initWithStatusCode:statusCode version:nil headers:nil];
}

- (instancetype)initWithVersion:(NSString *)version {
    return [self initWithStatusCode:200 version:version headers:nil];
}

- (instancetype)initWithHeaders:(NSDictionary<NSString *,NSString *> *)headers {
    return [self initWithStatusCode:200 version:nil headers:headers];
}

- (instancetype)initWithStatusCode:(NSInteger)statusCode version:(NSString *)version headers:(NSDictionary<NSString *,NSString *> *)headers {
    version = version? [version copy]:@"HTTP/1.1";
    headers = [headers copy];
    return [self initWithBlock:^NSURLResponse * _Nullable(NSURLResponse * _Nonnull response) {
        if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
            return  response;
        }
        NSMutableDictionary *mheaders = [((NSHTTPURLResponse *)response).allHeaderFields mutableCopy];
        for (NSString *header in headers) {
            NSString *value = headers[header];
            mheaders[header] = value;
        }
        NSHTTPURLResponse *httpResponse = [[NSHTTPURLResponse alloc] initWithURL:response.URL statusCode:statusCode HTTPVersion:version headerFields:[mheaders copy]];
        return httpResponse;
    }];
}

@end
