#define NSURLResponseUnknownLength ((long long)-1)

//  url  的响应内容
API_AVAILABLE(macos(10.2), ios(2.0), watchos(2.0), tvos(9.0))
@interface NSURLResponse : NSObject <NSSecureCoding, NSCopying>
{
    @package
    NSURLResponseInternal *_internal;
}

//  初始化
- (instancetype)initWithURL:(NSURL *)URL MIMEType:(nullable NSString *)MIMEType expectedContentLength:(NSInteger)length textEncodingName:(nullable NSString *)name NS_DESIGNATED_INITIALIZER;

//  url
@property (nullable, readonly, copy) NSURL *URL;

//  mime type 类型
@property (nullable, readonly, copy) NSString *MIMEType;

@property (readonly) long long expectedContentLength; // 预计内容长度
@property (nullable, readonly, copy) NSString *textEncodingName; // 文本的编码名字
@property (nullable, readonly, copy) NSString *suggestedFilename; // 预估的文件名字

@end

API_AVAILABLE(macos(10.2), ios(2.0), watchos(2.0), tvos(9.0))
@interface NSHTTPURLResponse : NSURLResponse 
{
    @package
    NSHTTPURLResponseInternal *_httpInternal;
}

//  初始化
- (nullable instancetype)initWithURL:(NSURL *)url statusCode:(NSInteger)statusCode HTTPVersion:(nullable NSString *)HTTPVersion headerFields:(nullable NSDictionary<NSString *, NSString *> *)headerFields API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0));


@property (readonly) NSInteger statusCode; // 状态码

// 所有头部字段
@property (readonly, copy) NSDictionary *allHeaderFields;
//  获取头部内容
- (nullable NSString *)valueForHTTPHeaderField:(NSString *)field API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0));

+ (NSString *)localizedStringForStatusCode:(NSInteger)statusCode; // 通过code俩获取描述

@end

NS_ASSUME_NONNULL_END
