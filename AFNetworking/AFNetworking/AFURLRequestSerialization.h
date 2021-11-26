// AFURLRequestSerialization.h
// Copyright (c) 2011–2016 Alamofire Software Foundation ( http://alamofire.org/ )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <TargetConditionals.h>

#if TARGET_OS_IOS || TARGET_OS_TV
#import <UIKit/UIKit.h>
#elif TARGET_OS_WATCH
#import <WatchKit/WatchKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 Returns a percent-escaped string following RFC 3986 for a query string key or value.
 RFC 3986 states that the following characters are "reserved" characters.
 - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
 - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="

 In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
 query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
 should be percent-escaped in the query string.
 
 @param string The string to be percent-escaped.
 
 @return The percent-escaped string.
 */
// url编码出来百分号
FOUNDATION_EXPORT NSString * AFPercentEscapedStringFromString(NSString *string);

// 请求参数的字符串 & 来分割
FOUNDATION_EXPORT NSString * AFQueryStringFromParameters(NSDictionary *parameters);

// 也就是这个系列化，通过系列化是设置在header field还是http body 里面，
// 都是这样设置？ 为啥还需要不同的系列化呢？
@protocol AFURLRequestSerialization <NSObject, NSSecureCoding, NSCopying>

/**
// 指定参数构建一个请求对象
 @param request 原始的请求
 @param parameters 参数
 @param error 构建的错误

 @return A serialized request.
 */
// 将有关的请求参数赋值到request上面
// NSURLRequest： 就是封装url请求的一些参数， 怎么去封装，这个要看一下是什么方式
- (nullable NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(nullable id)parameters
                                        error:(NSError * _Nullable __autoreleasing *)error NS_SWIFT_NOTHROW;

@end

#pragma mark -

/**
    系列化的而央视？ 为什么需要这样的样式
 */
typedef NS_ENUM(NSUInteger, AFHTTPRequestQueryStringSerializationStyle) {
    AFHTTPRequestQueryStringDefaultStyle = 0,
};

@protocol AFMultipartFormData;


// AFHTTPRequestSerializer 实现了AFURLRequestSerialization 接口的系列化基类， 提供了级版本的实现对于请求字符串的form-encoded参数系列化和默认的请求头部。
// 请求系列化
@interface AFHTTPRequestSerializer : NSObject <AFURLRequestSerialization>

//系列化参数的编码，默认是NSUTF8StringEncoding
@property (nonatomic, assign) NSStringEncoding stringEncoding;

// 允许窝蜂访问， 默认是YES
@property (nonatomic, assign) BOOL allowsCellularAccess;

// 缓存策略 ， 默认是NSURLRequestUseProtocolCachePolicy 
@property (nonatomic, assign) NSURLRequestCachePolicy cachePolicy;


// 是否处理cookies , 默认是YES，
@property (nonatomic, assign) BOOL HTTPShouldHandleCookies;

//  是否使用管道，默认是NO， 到时候看一下
//https://www.jianshu.com/p/26285148ec32
@property (nonatomic, assign) BOOL HTTPShouldUsePipelining;

// 网络服务类型
@property (nonatomic, assign) NSURLRequestNetworkServiceType networkServiceType;

// 超时时间
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

///---------------------------------------
/// @name Configuring HTTP Request Headers
///---------------------------------------


// 头部字段：
// 默认包括 Accept-Language User-Agent
// 也就是这里可以额外添加
@property (readonly, nonatomic, strong) NSDictionary <NSString *, NSString *> *HTTPRequestHeaders;

// 默认的系列对象
+ (instancetype)serializer;

// !nil 添加， nil移除
- (void)setValue:(nullable NSString *)value
forHTTPHeaderField:(NSString *)field;
- (nullable NSString *)valueForHTTPHeaderField:(NSString *)field;

// 设置验证的账户和密码
- (void)setAuthorizationHeaderFieldWithUsername:(NSString *)username
                                       password:(NSString *)password;

// 清楚头部额验证
- (void)clearAuthorizationHeader;

///-------------------------------------------------------
/// @name Configuring Query String Parameter Serialization
///-------------------------------------------------------

// 默认： `GET`, `HEAD`, and `DELETE`
// http 编码参数在URI中的方法 ， 也就是参数在URI中需要编码
@property (nonatomic, strong) NSSet <NSString *> *HTTPMethodsEncodingParametersInURI;

/**
 Set the method of query string serialization according to one of the pre-defined styles.

 @param style The serialization style.

 @see AFHTTPRequestQueryStringSerializationStyle
 */
// 设置查询字符串系列的样式
- (void)setQueryStringSerializationWithStyle:(AFHTTPRequestQueryStringSerializationStyle)style;

/**
 Set the a custom method of query string serialization according to the specified block.

 @param block A block that defines a process of encoding parameters into a query string. This block returns the query string and takes three arguments: the request, the parameters to encode, and the error that occurred when attempting to encode parameters for the given request.
 */
//通过block设置查询字符串锡类
- (void)setQueryStringSerializationWithBlock:(nullable NSString * _Nullable (^)(NSURLRequest *request, id parameters, NSError * __autoreleasing *error))block;

///-------------------------------
/// @name Creating Request Objects
///-------------------------------

// method: GET`, `HEAD`, or `DELETE` 方法是通过url-encoded 查询字符串的方式，也就是拼接，其他的是添加到情感求体里面
// URLString: 请求的URL
// parameters: 请求的参数
// error： 错误信息
- (nullable NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                          URLString:(NSString *)URLString
                                         parameters:(nullable id)parameters
                                              error:(NSError * _Nullable __autoreleasing *)error;

/**
// 包括了字符流等， 视频，音频等
 // 构建一个`multipart/form-data` HTTP body ， 使用指定的参数和multipart 格式数据的block
 //http://www.w3.org/TR/html4/interact/forms.html#h-17.13.4.2 mutipart form
 
 Multipart form requests are automatically streamed, reading files directly from disk along with in-memory data in a single HTTP body. The resulting `NSMutableURLRequest` object has an `HTTPBodyStream` property, so refrain from setting `HTTPBodyStream` or `HTTPBody` on this request object, as it will clear out the multipart form body stream.

 @param method 方法参数，，不可以是GET， HEAD,nil
 @param URLString url
 @param parameters 参数
 @param block  一些简单的参数添加到mutipart 里面， 采用了AFMultipartFormData 接口
 @param error 错误信息
 */
// mutable form  感觉一般是用来上传数据
- (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method
                                              URLString:(NSString *)URLString
                                             parameters:(nullable NSDictionary <NSString *, id> *)parameters
                              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                                  error:(NSError * _Nullable __autoreleasing *)error;

/**
// 创建一个通过移除request中额HTTPBodyStream， 和异步写它的内容到指定文件中，当调用完成处理

 @param request request中的HTTPBodyStream 必须不是nil
 @param fileURL 文件的url
 @param handler 处理的block

 @discussion There is a bug in `NSURLSessionTask` that causes requests to not send a `Content-Length` header when streaming contents from an HTTP body, which is notably problematic when interacting with the Amazon S3 webservice. As a workaround, this method takes a request constructed with `multipartFormRequestWithMethod:URLString:parameters:constructingBodyWithBlock:error:`, or any other request with an `HTTPBodyStream`, writes the contents to the specified file and returns a copy of the original request with the `HTTPBodyStream` property set to `nil`. From here, the file can either be passed to `AFURLSessionManager -uploadTaskWithRequest:fromFile:progress:completionHandler:`, or have its contents read into an `NSData` that's assigned to the `HTTPBody` property of the request.

 @see https://github.com/AFNetworking/AFNetworking/issues/1398
 */
// 通过一个multipart form的urlrequest来构建一个request
- (NSMutableURLRequest *)requestWithMultipartFormRequest:(NSURLRequest *)request
                             writingStreamContentsToFile:(NSURL *)fileURL
                                       completionHandler:(nullable void (^)(NSError * _Nullable error))handler;

@end

#pragma mark -


// multipartForm  这种格式的data内容
/**
 The `AFMultipartFormData` protocol defines the methods supported by the parameter in the block argument of `AFHTTPRequestSerializer -multipartFormRequestWithMethod:URLString:parameters:constructingBodyWithBlock:error:`.
 */
@protocol AFMultipartFormData

/**
 Appends the HTTP header `Content-Disposition: file; filename=#{generated filename}; name=#{name}"` and `Content-Type: #{generated mimeType}`, followed by the encoded file data and the multipart form boundary.

 The filename and MIME type for this data in the form will be automatically generated, using the last path component of the `fileURL` and system associated MIME type for the `fileURL` extension, respectively.

 @param fileURL The URL corresponding to the file whose content will be appended to the form. This parameter must not be `nil`.
 @param name The name to be associated with the specified data. This parameter must not be `nil`.
 @param error If an error occurs, upon return contains an `NSError` object that describes the problem.

 @return `YES` if the file data was successfully appended, otherwise `NO`.
 */
// 添加内容 ， 也就是拼接url指定的file的内容，这个内容对应的名字是name（新的名字）
- (BOOL)appendPartWithFileURL:(NSURL *)fileURL
                         name:(NSString *)name
                        error:(NSError * _Nullable __autoreleasing *)error;

/**
 Appends the HTTP header `Content-Disposition: file; filename=#{filename}; name=#{name}"` and `Content-Type: #{mimeType}`, followed by the encoded file data and the multipart form boundary.

 @param fileURL The URL corresponding to the file whose content will be appended to the form. This parameter must not be `nil`.
 @param name The name to be associated with the specified data. This parameter must not be `nil`.
 @param fileName Content-Disposition 字段的值 header. nonil
 @param mimeType 原始数据类型， nonil
 @param error If an error occurs, upon return contains an `NSError` object that describes the problem.

 @return `YES` if the file data was successfully appended otherwise `NO`.
 */
// mimeType
//https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Content-Disposition 这个字段的内容，是内容还是附件的方式
//https://cloud.tencent.com/developer/section/1189916
- (BOOL)appendPartWithFileURL:(NSURL *)fileURL
                         name:(NSString *)name
                     fileName:(NSString *)fileName
                     mimeType:(NSString *)mimeType
                        error:(NSError * _Nullable __autoreleasing *)error;

/**
 Appends the HTTP header `Content-Disposition: file; filename=#{filename}; name=#{name}"` and `Content-Type: #{mimeType}`, followed by the data from the input stream and the multipart form boundary.

 @param inputStream The input stream to be appended to the form data
 @param name The name to be associated with the specified input stream. This parameter must not be `nil`.
 @param fileName The filename to be associated with the specified input stream. This parameter must not be `nil`.
 @param length The length of the specified input stream in bytes.
 @param mimeType The MIME type of the specified data. (For example, the MIME type for a JPEG image is image/jpeg.) For a list of valid MIME types, see http://www.iana.org/assignments/media-types/. This parameter must not be `nil`.
 */
// 输入流进行扩展
- (void)appendPartWithInputStream:(nullable NSInputStream *)inputStream
                             name:(NSString *)name
                         fileName:(NSString *)fileName
                           length:(int64_t)length
                         mimeType:(NSString *)mimeType;

/**
 Appends the HTTP header `Content-Disposition: file; filename=#{filename}; name=#{name}"` and `Content-Type: #{mimeType}`, followed by the encoded file data and the multipart form boundary.

 @param data The data to be encoded and appended to the form data.
 @param name The name to be associated with the specified data. This parameter must not be `nil`.
 @param fileName The filename to be associated with the specified data. This parameter must not be `nil`.
 @param mimeType The MIME type of the specified data. (For example, the MIME type for a JPEG image is image/jpeg.) For a list of valid MIME types, see http://www.iana.org/assignments/media-types/. This parameter must not be `nil`.
 */
// 数据扩展
- (void)appendPartWithFileData:(NSData *)data
                          name:(NSString *)name
                      fileName:(NSString *)fileName
                      mimeType:(NSString *)mimeType;

/**
 Appends the HTTP headers `Content-Disposition: form-data; name=#{name}"`, followed by the encoded data and the multipart form boundary.

 @param data The data to be encoded and appended to the form data.
 @param name The name to be associated with the specified data. This parameter must not be `nil`.
 */

- (void)appendPartWithFormData:(NSData *)data
                          name:(NSString *)name;


/**
 Appends HTTP headers, followed by the encoded data and the multipart form boundary.

 @param headers The HTTP headers to be appended to the form data.
 @param body The data to be encoded and appended to the form data. This parameter must not be `nil`.
 */
// 头部和body
- (void)appendPartWithHeaders:(nullable NSDictionary <NSString *, NSString *> *)headers
                         body:(NSData *)body;

/**
 Throttles request bandwidth by limiting the packet size and adding a delay for each chunk read from the upload stream.

 When uploading over a 3G or EDGE connection, requests may fail with "request body stream exhausted". Setting a maximum packet size and delay according to the recommended values (`kAFUploadStream3GSuggestedPacketSize` and `kAFUploadStream3GSuggestedDelay`) lowers the risk of the input stream exceeding its allocated bandwidth. Unfortunately, there is no definite way to distinguish between a 3G, EDGE, or LTE connection over `NSURLConnection`. As such, it is not recommended that you throttle bandwidth based solely on network reachability. Instead, you should consider checking for the "request body stream exhausted" in a failure block, and then retrying the request with throttled bandwidth.

 @param numberOfBytes  最大的包大小， Maximum packet size, in number of bytes. The default packet size for an input stream is 16kb.
 @param delay Duration of delay each time a packet is read. By default, no delay is set.
 */
//
- (void)throttleBandwidthWithPacketSize:(NSUInteger)numberOfBytes
                                  delay:(NSTimeInterval)delay;

@end

#pragma mark -

// 设置Content-Type=application/json ， 使用NSJSONSerialization来进行编码
@interface AFJSONRequestSerializer : AFHTTPRequestSerializer

// json写的选项
//typedef NS_OPTIONS(NSUInteger, NSJSONWritingOptions) {
//指定输出使用空白和缩进使生成的数据更具可读性。
//    NSJSONWritingPrettyPrinted = (1UL << 0),

// 具有排序的功能 ，通过系统本地，通过NSNumericSearch 来进行排序
//    NSJSONWritingSortedKeys API_AVAILABLE(macos(10.13), ios(11.0), watchos(4.0), tvos(11.0)) = (1UL << 1),

//指定解析的应该是顶级的对象，而不是数组或者字典
//    NSJSONWritingFragmentsAllowed = (1UL << 2),

//指定输出不使用转义字符作为斜杠字符的前缀。
//    NSJSONWritingWithoutEscapingSlashes API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0)) = (1UL << 3),
//};

// 从对象中协成json数据。 默认是0
@property (nonatomic, assign) NSJSONWritingOptions writingOptions;

// 系列化初始化方法
+ (instancetype)serializerWithWritingOptions:(NSJSONWritingOptions)writingOptions;

@end

#pragma mark -


// 继承 AFHTTPRequestSerializer 和 json类似使用了NSPropertyListSerializer ，
// 设置Content-Type=application/x-plist
// 这个东西有待去研究一下
// propertylist的请求系列化
@interface AFPropertyListRequestSerializer : AFHTTPRequestSerializer

// list的类型：
//typedef NS_ENUM(NSUInteger, NSPropertyListFormat) {
//    NSPropertyListOpenStepFormat = kCFPropertyListOpenStepFormat, // 打开的格式， 常规格式
//    NSPropertyListXMLFormat_v1_0 = kCFPropertyListXMLFormat_v1_0, // xml格式
//    NSPropertyListBinaryFormat_v1_0 = kCFPropertyListBinaryFormat_v1_0 // 二进制格式
//};
@property (nonatomic, assign) NSPropertyListFormat format;


/**
 @warning The `writeOptions` property is currently unused.
 */
// 目前不适用了， 不过是一个写的额选项，默认0 就行了
@property (nonatomic, assign) NSPropertyListWriteOptions writeOptions;

// 创建一个serializer
+ (instancetype)serializerWithFormat:(NSPropertyListFormat)format
                        writeOptions:(NSPropertyListWriteOptions)writeOptions;

@end

#pragma mark -

///----------------
/// @name Constants
///----------------

/**
 ## Error Domains

 The following error domain is predefined.

 - `NSString * const AFURLRequestSerializationErrorDomain`

 ### Constants

 `AFURLRequestSerializationErrorDomain`
 AFURLRequestSerializer errors. Error codes for `AFURLRequestSerializationErrorDomain` correspond to codes in `NSURLErrorDomain`.
 */
FOUNDATION_EXPORT NSString * const AFURLRequestSerializationErrorDomain;

/**
 ## User info dictionary keys

 These keys may exist in the user info dictionary, in addition to those defined for NSError.

 - `NSString * const AFNetworkingOperationFailingURLRequestErrorKey`

 ### Constants

 `AFNetworkingOperationFailingURLRequestErrorKey`
 The corresponding value is an `NSURLRequest` containing the request of the operation associated with an error. This key is only present in the `AFURLRequestSerializationErrorDomain`.
 */
FOUNDATION_EXPORT NSString * const AFNetworkingOperationFailingURLRequestErrorKey;

/**
 ## Throttling Bandwidth for HTTP Request Input Streams

 @see -throttleBandwidthWithPacketSize:delay:

 ### Constants

 `kAFUploadStream3GSuggestedPacketSize`
 Maximum packet size, in number of bytes. Equal to 16kb.

 `kAFUploadStream3GSuggestedDelay`
 Duration of delay each time a packet is read. Equal to 0.2 seconds.
 */
FOUNDATION_EXPORT NSUInteger const kAFUploadStream3GSuggestedPacketSize;
FOUNDATION_EXPORT NSTimeInterval const kAFUploadStream3GSuggestedDelay;

NS_ASSUME_NONNULL_END
