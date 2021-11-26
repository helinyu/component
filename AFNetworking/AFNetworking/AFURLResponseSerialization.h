// AFURLResponseSerialization.h
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
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Recursively removes `NSNull` values from a JSON object.
*/
FOUNDATION_EXPORT id AFJSONObjectByRemovingKeysWithNullValues(id JSONObject, NSJSONReadingOptions readingOptions);

/**
 这个接口用于将数据解码为更加有用的数据对西安共in，根据服务器响应的数据。  响应类别组可以更加有效处理
eg：json响应系列可能检查对于一个可接受的状态码和content type `application/json` ， 解码json数据变成对象
 */

// 响应的系列化。 也就是网络数据对应本地机器进行系列化
@protocol AFURLResponseSerialization <NSObject, NSSecureCoding, NSCopying>

/**

 @param response 响应
 @param data 被解码的数据
 @param error

 */
// urlresponse 转化为对对应的obj
- (nullable id)responseObjectForResponse:(nullable NSURLResponse *)response
                           data:(nullable NSData *)data
                          error:(NSError * _Nullable __autoreleasing *)error NS_SWIFT_NOTHROW;

@end

#pragma mark -

// http的响应系列化
// AFURLResponseSerialization 接口实现
// 提供了一个 query string / URL form-encoded parameter和默认请求偷的响应处理。 确定一直的默认行为
@interface AFHTTPResponseSerializer : NSObject <AFURLResponseSerialization>

- (instancetype)init;

// 默认配置系列化
+ (instancetype)serializer;

///-----------------------------------------
/// @name Configuring Response Serialization
///-----------------------------------------

/**
 查看：http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
 http status codes ,响应码， nonil ， 返回的响应码不再这里的话，将会导致错误
 */
//
@property (nonatomic, copy, nullable) NSIndexSet *acceptableStatusCodes;

// 接收的类型，`Content-Type` with MIME types 是否吃吃
@property (nonatomic, copy, nullable) NSSet <NSString *> *acceptableContentTypes;


//检查是否响应是否有效
- (BOOL)validateResponse:(nullable NSHTTPURLResponse *)response
                    data:(nullable NSData *)data
                   error:(NSError * _Nullable __autoreleasing *)error;

@end

#pragma mark -


/**
 `AFJSONResponseSerializer` is a subclass of `AFHTTPResponseSerializer` that validates and decodes JSON responses.

 By default, `AFJSONResponseSerializer` accepts the following MIME types, which includes the official standard, `application/json`, as well as other commonly-used types:

  // 默认就是这三种的数据
 - `application/json`
 - `text/json`
 - `text/javascript`

 In RFC 7159 - Section 8.1, it states that JSON text is required to be encoded in UTF-8, UTF-16, or UTF-32, and the default encoding is UTF-8. NSJSONSerialization provides support for all the encodings listed in the specification, and recommends UTF-8 for efficiency. Using an unsupported encoding will result in serialization error. See the `NSJSONSerialization` documentation for more details.
 */
// json的响应协力恶化
@interface AFJSONResponseSerializer : AFHTTPResponseSerializer

- (instancetype)init;

// 读的选项 ， 默认是0 ， 读repsonsejson和创建foundation对象
@property (nonatomic, assign) NSJSONReadingOptions readingOptions;

// 默认是NO， 是否移除值为NSNull的key。 默认是NO
@property (nonatomic, assign) BOOL removesKeysWithNullValues;

// 系列读取的选项
+ (instancetype)serializerWithReadingOptions:(NSJSONReadingOptions)readingOptions;

@end

#pragma mark -

/**
 `AFXMLParserResponseSerializer` is a subclass of `AFHTTPResponseSerializer` that validates and decodes XML responses as an `NSXMLParser` objects.
 支持这两格式
 - `application/xml`
 - `text/xml`
 */

// msl的解析
@interface AFXMLParserResponseSerializer : AFHTTPResponseSerializer

@end

#pragma mark -

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED

/**
 界面xml响应成为一个NSXMLDocument 对象
  默认是AFXMLDocumentResponseSerializer， 支持官方的`application/xml` ， 也包括场常使用的
 - `application/xml`
 - `text/xml`
 */
@interface AFXMLDocumentResponseSerializer : AFHTTPResponseSerializer

- (instancetype)init;

// 输入和输出的选项， 默认是0， 可以以查看 NSXMLDocument的章节
@property (nonatomic, assign) NSUInteger options;

/**

 @param mask The XML document options.
 */
// 系列化，
+ (instancetype)serializerWithXMLDocumentOptions:(NSUInteger)mask;

@end

#endif

#pragma mark -

/**
返回的xml解码成为`NSXMLDocument`对象， 默认的minetype 是 - `application/x-plist`
 */
@interface AFPropertyListResponseSerializer : AFHTTPResponseSerializer

- (instancetype)init;

//格式
@property (nonatomic, assign) NSPropertyListFormat format;

// 读的选项
@property (nonatomic, assign) NSPropertyListReadOptions readOptions;


// 系列化
+ (instancetype)serializerWithFormat:(NSPropertyListFormat)format
                         readOptions:(NSPropertyListReadOptions)readOptions;

@end

#pragma mark -

/**
 默认的类型是图片对应的雷兴国
 
 - `image/tiff`
 - `image/jpeg`
 - `image/gif`
 - `image/png`
 - `image/ico`
 - `image/x-icon`
 - `image/bmp`
 - `image/x-bmp`
 - `image/x-xbitmap`
 - `image/x-win-bitmap`
 */
@interface AFImageResponseSerializer : AFHTTPResponseSerializer

#if TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_WATCH

// 图片的倍率，默认是1
@property (nonatomic, assign) CGFloat imageScale;

/**
 Whether to automatically inflate response image data for compressed formats (such as PNG or JPEG). Enabling this can significantly improve drawing performance on iOS when used with `setCompletionBlockWithSuccess:failure:`, as it allows a bitmap representation to be constructed in the background rather than on the main thread. `YES` by default.
 */
// 是否自动填充响应图片， 默认是YES
@property (nonatomic, assign) BOOL automaticallyInflatesResponseImage;
#endif

@end

#pragma mark -

/**
 `AFCompoundSerializer` is a subclass of `AFHTTPResponseSerializer` that delegates the response serialization to the first `AFHTTPResponseSerializer` object that returns an object for `responseObjectForResponse:data:error:`, falling back on the default behavior of `AFHTTPResponseSerializer`. This is useful for supporting multiple potential types and structures of server responses with a single serializer.
 */
// 符合不同的数据结构的心相映处理
// 也就是， 这几个，主要我用一个能够解析就可以了
@interface AFCompoundResponseSerializer : AFHTTPResponseSerializer

/**
 The component response serializers.
 */
@property (readonly, nonatomic, copy) NSArray <id<AFURLResponseSerialization>> *responseSerializers;

/**
 Creates and returns a compound serializer comprised of the specified response serializers.

 @warning Each response serializer specified must be a subclass of `AFHTTPResponseSerializer`, and response to `-validateResponse:data:error:`.
 */
+ (instancetype)compoundSerializerWithResponseSerializers:(NSArray <id<AFURLResponseSerialization>> *)responseSerializers;

@end

///----------------
/// @name Constants
///----------------

FOUNDATION_EXPORT NSString * const AFURLResponseSerializationErrorDomain; // 错误的domain

FOUNDATION_EXPORT NSString * const AFNetworkingOperationFailingURLResponseErrorKey; // 响应错误的key

FOUNDATION_EXPORT NSString * const AFNetworkingOperationFailingURLResponseDataErrorKey; //响应数据错误的key

NS_ASSUME_NONNULL_END
