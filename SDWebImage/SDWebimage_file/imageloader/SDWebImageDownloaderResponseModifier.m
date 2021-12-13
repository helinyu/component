// SDWebImageDownloaderResponseModifier 响应的修改器

typedef NSURLResponse * _Nullable (^SDWebImageDownloaderResponseModifierBlock)(NSURLResponse * _Nonnull response);

@protocol SDWebImageDownloaderResponseModifier <NSObject>
- (nullable NSURLResponse *)modifiedResponseWithResponse:(nonnull NSURLResponse *)response;

@end

// 响应修修改器
@interface SDWebImageDownloaderResponseModifier : NSObject <SDWebImageDownloaderResponseModifier>

- (nonnull instancetype)initWithBlock:(nonnull SDWebImageDownloaderResponseModifierBlock)block;
+ (nonnull instancetype)responseModifierWithBlock:(nonnull SDWebImageDownloaderResponseModifierBlock)block;

@end
@interface SDWebImageDownloaderResponseModifier (Conveniences)
- (nonnull instancetype)initWithStatusCode:(NSInteger)statusCode;
- (nonnull instancetype)initWithVersion:(nullable NSString *)version;
- (nonnull instancetype)initWithHeaders:(nullable NSDictionary<NSString *, NSString *> *)headers;
- (nonnull instancetype)initWithStatusCode:(NSInteger)statusCode version:(nullable NSString *)version headers:(nullable NSDictionary<NSString *, NSString *> *)headers;

@end

@interface SDWebImageDownloaderResponseModifier ()

@property (nonatomic, copy, nonnull) SDWebImageDownloaderResponseModifierBlock block;

@end

@implementation SDWebImageDownloaderResponseModifier

- (instancetype)initWithBlock:(SDWebImageDownloaderResponseModifierBlock)block {
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

+ (instancetype)responseModifierWithBlock:(SDWebImageDownloaderResponseModifierBlock)block {
    SDWebImageDownloaderResponseModifier *responseModifier = [[SDWebImageDownloaderResponseModifier alloc] initWithBlock:block];
    return responseModifier;
}

- (nullable NSURLResponse *)modifiedResponseWithResponse:(nonnull NSURLResponse *)response {
    if (!self.block) {
        return nil;
    }
    return self.block(response);
}

@end

@implementation SDWebImageDownloaderResponseModifier (Conveniences)

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
    version = version ? [version copy] : @"HTTP/1.1";
    headers = [headers copy];
    return [self initWithBlock:^NSURLResponse * _Nullable(NSURLResponse * _Nonnull response) {
        if (![response isKindOfClass:NSHTTPURLResponse.class]) {
            return response;
        }
        NSMutableDictionary *mutableHeaders = [((NSHTTPURLResponse *)response).allHeaderFields mutableCopy];
        for (NSString *header in headers) {
            NSString *value = headers[header];
            mutableHeaders[header] = value;
        }
        NSHTTPURLResponse *httpResponse = [[NSHTTPURLResponse alloc] initWithURL:response.URL statusCode:statusCode HTTPVersion:version headerFields:[mutableHeaders copy]];
        return httpResponse;
    }];
}

@end

//  需要一个例子来进行对这个内容进行修改， 这个内容会有什么问题呢？


