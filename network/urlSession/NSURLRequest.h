
//  可变对象和不可变对象

NS_ASSUME_NONNULL_BEGIN

/*!
    @header NSURLRequest.h

    This header file describes the constructs used to represent URL
    load requests in a manner independent of protocol and URL scheme.
    Immutable and mutable variants of this URL load request concept
    are described, named NSURLRequest and NSMutableURLRequest,
    respectively. A collection of constants is also declared to
    exercise control over URL content caching policy.

    <p>NSURLRequest and NSMutableURLRequest are designed to be
    customized to support protocol-specific requests. Protocol
    implementors who need to extend the capabilities of NSURLRequest
    and NSMutableURLRequest are encouraged to provide categories on
    these classes as appropriate to support protocol-specific data. To
    store and retrieve data, category methods can use the
    <tt>+propertyForKey:inRequest:</tt> and
    <tt>+setProperty:forKey:inRequest:</tt> class methods on
    NSURLProtocol. See the NSHTTPURLRequest on NSURLRequest and
    NSMutableHTTPURLRequest on NSMutableURLRequest for examples of
    such extensions.

    <p>The main advantage of this design is that a client of the URL
    loading library can implement request policies in a standard way
    without type checking of requests or protocol checks on URLs. Any
    protocol-specific details that have been set on a URL request will
    be used if they apply to the particular URL being loaded, and will
    be ignored if they do not apply.
*/

/*!
    @enum NSURLRequestCachePolicy

    @discussion The NSURLRequestCachePolicy enum defines constants that
    can be used to specify the type of interactions that take place with
    the caching system when the URL loading system processes a request.
    Specifically, these constants cover interactions that have to do
    with whether already-existing cache data is returned to satisfy a
    URL load request.

    @constant NSURLRequestUseProtocolCachePolicy Specifies that the
    caching logic defined in the protocol implementation, if any, is
    used for a particular URL load request. This is the default policy
    for URL load requests.

    @constant NSURLRequestReloadIgnoringLocalCacheData Specifies that the
    data for the URL load should be loaded from the origin source. No
    existing local cache data, regardless of its freshness or validity,
    should be used to satisfy a URL load request.

    @constant NSURLRequestReloadIgnoringLocalAndRemoteCacheData Specifies that
    not only should the local cache data be ignored, but that proxies and
    other intermediates should be instructed to disregard their caches
    so far as the protocol allows.

    @constant NSURLRequestReloadIgnoringCacheData Older name for
    NSURLRequestReloadIgnoringLocalCacheData.

    @constant NSURLRequestReturnCacheDataElseLoad Specifies that the
    existing cache data should be used to satisfy a URL load request,
    regardless of its age or expiration date. However, if there is no
    existing data in the cache corresponding to a URL load request,
    the URL is loaded from the origin source.

    @constant NSURLRequestReturnCacheDataDontLoad Specifies that the
    existing cache data should be used to satisfy a URL load request,
    regardless of its age or expiration date. However, if there is no
    existing data in the cache corresponding to a URL load request, no
    attempt is made to load the URL from the origin source, and the
    load is considered to have failed. This constant specifies a
    behavior that is similar to an "offline" mode.

    @constant NSURLRequestReloadRevalidatingCacheData Specifies that
    the existing cache data may be used provided the origin source
    confirms its validity, otherwise the URL is loaded from the
    origin source.
*/
typedef NS_ENUM(NSUInteger, NSURLRequestCachePolicy)
{
    NSURLRequestUseProtocolCachePolicy = 0,

    NSURLRequestReloadIgnoringLocalCacheData = 1,
    NSURLRequestReloadIgnoringLocalAndRemoteCacheData = 4,
    NSURLRequestReloadIgnoringCacheData = NSURLRequestReloadIgnoringLocalCacheData,

    NSURLRequestReturnCacheDataElseLoad = 2,
    NSURLRequestReturnCacheDataDontLoad = 3,

    NSURLRequestReloadRevalidatingCacheData = 5,
};

//  几个缓存的策略
typedef NS_ENUM(NSUInteger, NSURLRequestCachePolicy)
{
    NSURLRequestUseProtocolCachePolicy = 0, //默认 使用缓存
    NSURLRequestReloadIgnoringLocalCacheData = 1, //忽略缓存，每次都请求新的数据
    NSURLRequestReloadIgnoringLocalAndRemoteCacheData = 4, // Unimplemented
    NSURLRequestReloadIgnoringCacheData = NSURLRequestReloadIgnoringLocalCacheData,

    NSURLRequestReturnCacheDataElseLoad = 2,
    //如果在之前的网络请求中，我们获取了Cache的Response，那么本次请求同样的接口，就直接从Cache中去抓。反之，从服务器上去获取，并在本地cache起来。

    NSURLRequestReturnCacheDataDontLoad = 3,
     //只从缓存中获取cached response而不从服务器获取。实属离线版本。

    NSURLRequestReloadRevalidatingCacheData = 5, // Unimplemented
};


/*!
 @enum NSURLRequestNetworkServiceType
 
 @discussion The NSURLRequestNetworkServiceType enum defines constants that
 can be used to specify the service type to associate with this request.  The
 service type is used to provide the networking layers a hint of the purpose 
 of the request.
 
 @constant NSURLNetworkServiceTypeDefault Is the default value for an NSURLRequest
 when created.  This value should be left unchanged for the vast majority of requests.
 
 @constant NSURLNetworkServiceTypeVoIP Specifies that the request is for voice over IP
 control traffic.
 
 @constant NSURLNetworkServiceTypeVideo Specifies that the request is for video
 traffic.

 @constant NSURLNetworkServiceTypeBackground Specifies that the request is for background
 traffic (such as a file download).

 @constant NSURLNetworkServiceTypeVoice Specifies that the request is for voice data.

 @constant NSURLNetworkServiceTypeResponsiveData Specifies that the request is for responsive (time sensitive) data.

 @constant NSURLNetworkServiceTypeAVStreaming Specifies that the request is streaming audio/video data.

 @constant NSURLNetworkServiceTypeResponsiveAV Specifies that the request is for responsive (time sensitive) audio/video data.

 @constant NSURLNetworkServiceTypeCallSignaling Specifies that the request is for call signaling.
*/
typedef NS_ENUM(NSUInteger, NSURLRequestNetworkServiceType)
{
    NSURLNetworkServiceTypeDefault = 0,	// Standard internet traffic
    NSURLNetworkServiceTypeVoIP API_DEPRECATED("Use PushKit for VoIP control purposes", macos(10.7,10.15), ios(4.0,13.0), watchos(2.0,6.0), tvos(9.0,13.0)) = 1,	// Voice over IP control traffic
    NSURLNetworkServiceTypeVideo = 2,	// Video traffic
    NSURLNetworkServiceTypeBackground = 3, // Background traffic
    NSURLNetworkServiceTypeVoice = 4,	   // Voice data
    NSURLNetworkServiceTypeResponsiveData = 6, // Responsive data
    NSURLNetworkServiceTypeAVStreaming API_AVAILABLE(macosx(10.9), ios(7.0), watchos(2.0), tvos(9.0)) = 8 , // Multimedia Audio/Video Streaming
    NSURLNetworkServiceTypeResponsiveAV API_AVAILABLE(macosx(10.9), ios(7.0), watchos(2.0), tvos(9.0)) = 9, // Responsive Multimedia Audio/Video
    NSURLNetworkServiceTypeCallSignaling API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0)) = 11, // Call Signaling
};

/*!
 @enum NSURLRequestAttribution

 @discussion The NSURLRequestAttribution enum is used to indicate whether the
 user or developer specified the URL.

 @constant NSURLRequestAttributionDeveloper Indicates that the URL was specified
 by the developer. This is the default value for an NSURLRequest when created.

 @constant NSURLRequestAttributionUser Indicates that the URL was specified by
 the user.
*/
//  url 请求的属性 ， 默认是developer
typedef NS_ENUM(NSUInteger, NSURLRequestAttribution)
{
    NSURLRequestAttributionDeveloper = 0,
    NSURLRequestAttributionUser = 1,
} API_AVAILABLE(macos(12.0), ios(15.0), watchos(8.0), tvos(15.0));

/*!
    @class NSURLRequest
    
    @abstract An NSURLRequest object represents a URL load request in a
    manner independent of protocol and URL scheme.
    
    @discussion NSURLRequest encapsulates two basic data elements about
    a URL load request:
    <ul>
    <li>The URL to load.
    <li>The policy to use when consulting the URL content cache made
    available by the implementation.
    </ul>
    In addition, NSURLRequest is designed to be extended to support
    protocol-specific data by adding categories to access a property
    object provided in an interface targeted at protocol implementors.
    <ul>
    <li>Protocol implementors should direct their attention to the
    NSURLRequestExtensibility category on NSURLRequest for more
    information on how to provide extensions on NSURLRequest to
    support protocol-specific request information.
    <li>Clients of this API who wish to create NSURLRequest objects to
    load URL content should consult the protocol-specific NSURLRequest
    categories that are available. The NSHTTPURLRequest category on
    NSURLRequest is an example.
    </ul>
    <p>
    Objects of this class are used to create NSURLConnection instances,
    which can are used to perform the load of a URL, or as input to the
    NSURLConnection class method which performs synchronous loads.
*/
API_AVAILABLE(macos(10.2), ios(2.0), watchos(2.0), tvos(9.0))
@interface NSURLRequest : NSObject <NSSecureCoding, NSCopying, NSMutableCopying>
{
    @private
    NSURLRequestInternal *_internal;
}

// 初始化
+ (instancetype)requestWithURL:(NSURL *)URL;

//  是否支持安全编码
@property (class, readonly) BOOL supportsSecureCoding;


// 初始化方法
+ (instancetype)requestWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval;
- (instancetype)initWithURL:(NSURL *)URL;
- (instancetype)initWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval NS_DESIGNATED_INITIALIZER;



@property (nullable, readonly, copy) NSURL *URL; // url
@property (readonly) NSURLRequestCachePolicy cachePolicy; // 缓存策略
@property (readonly) NSTimeInterval timeoutInterval; // 超时

@property (nullable, readonly, copy) NSURL *mainDocumentURL; // 住文档的url

@property (readonly) NSURLRequestNetworkServiceType networkServiceType API_AVAILABLE(macos(10.7), ios(4.0), watchos(2.0), tvos(9.0));
//  网络服务的类型

@property (readonly) BOOL allowsCellularAccess  API_AVAILABLE(macos(10.8), ios(6.0), watchos(2.0), tvos(9.0));
@property (readonly) BOOL allowsExpensiveNetworkAccess API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0));
@property (readonly) BOOL allowsConstrainedNetworkAccess API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0));
@property (readonly) BOOL assumesHTTP3Capable API_AVAILABLE(macos(11.3), ios(14.5), watchos(7.4), tvos(14.5))
@property (readonly) NSURLRequestAttribution attribution API_AVAILABLE(macos(12.0), ios(15.0), watchos(8.0), tvos(15.0));

@end



/*! 
    @class NSMutableURLRequest
    
    @abstract An NSMutableURLRequest object represents a mutable URL load
    request in a manner independent of protocol and URL scheme.
    
    @discussion This specialization of NSURLRequest is provided to aid
    developers who may find it more convenient to mutate a single request
    object for a series of URL loads instead of creating an immutable
    NSURLRequest for each load. This programming model is supported by
    the following contract stipulation between NSMutableURLRequest and 
    NSURLConnection: NSURLConnection makes a deep copy of each 
    NSMutableURLRequest object passed to one of its initializers.    
    <p>NSMutableURLRequest is designed to be extended to support
    protocol-specific data by adding categories to access a property
    object provided in an interface targeted at protocol implementors.
    <ul>
    <li>Protocol implementors should direct their attention to the
    NSMutableURLRequestExtensibility category on
    NSMutableURLRequest for more information on how to provide
    extensions on NSMutableURLRequest to support protocol-specific
    request information.
    <li>Clients of this API who wish to create NSMutableURLRequest
    objects to load URL content should consult the protocol-specific
    NSMutableURLRequest categories that are available. The
    NSMutableHTTPURLRequest category on NSMutableURLRequest is an
    example.
    </ul>
*/

//  对应的一些属性的设置
API_AVAILABLE(macos(10.2), ios(2.0), watchos(2.0), tvos(9.0))
@interface NSMutableURLRequest : NSURLRequest

/*! 
    @abstract The URL of the receiver.
*/
@property (nullable, copy) NSURL *URL;
@property NSURLRequestCachePolicy cachePolicy;
@property NSTimeInterval timeoutInterval;
@property (nullable, copy) NSURL *mainDocumentURL;
@property NSURLRequestNetworkServiceType networkServiceType API_AVAILABLE(macos(10.7), ios(4.0), watchos(2.0), tvos(9.0));
@property BOOL allowsCellularAccess API_AVAILABLE(macos(10.8), ios(6.0), watchos(2.0), tvos(9.0)); // 允许窝蜂网络
@property BOOL allowsExpensiveNetworkAccess API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0)); // 允许昂贵的网络
@property BOOL allowsConstrainedNetworkAccess API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0)); // 设置当用户指定低数据模式（Low Data Mode）时连接是否可以使用网络，默认为 true。 //是否允许请求在受限模式网络中进行，默认为yes
@property BOOL assumesHTTP3Capable API_AVAILABLE(macos(11.3), ios(14.5), watchos(7.4), tvos(14.5));
@property NSURLRequestAttribution attribution API_AVAILABLE(macos(12.0), ios(15.0), watchos(8.0), tvos(15.0));

@end


@interface NSURLRequest (NSHTTPURLRequest) 
@property (nullable, readonly, copy) NSString *HTTPMethod;
@property (nullable, readonly, copy) NSDictionary<NSString *, NSString *> *allHTTPHeaderFields;
- (nullable NSString *)valueForHTTPHeaderField:(NSString *)field;
@property (nullable, readonly, copy) NSData *HTTPBody;
@property (nullable, readonly, retain) NSInputStream *HTTPBodyStream;
@property (readonly) BOOL HTTPShouldHandleCookies;
@property (readonly) BOOL HTTPShouldUsePipelining API_AVAILABLE(macos(10.7), ios(4.0), watchos(2.0), tvos(9.0));

@end



//  可以设置一些属性
@interface NSMutableURLRequest (NSMutableHTTPURLRequest) 

@property (copy) NSString *HTTPMethod;
@property (nullable, copy) NSDictionary<NSString *, NSString *> *allHTTPHeaderFields;
- (void)setValue:(nullable NSString *)value forHTTPHeaderField:(NSString *)field;
- (void)addValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

//  body内容 
@property (nullable, copy) NSData *HTTPBody;
@property (nullable, retain) NSInputStream *HTTPBodyStream;

@property BOOL HTTPShouldHandleCookies; // cooke处理
@property BOOL HTTPShouldUsePipelining API_AVAILABLE(macos(10.7), ios(4.0), watchos(2.0), tvos(9.0)); // 管线处理

@end

NS_ASSUME_NONNULL_END


// https://juejin.cn/post/6977299370106421261 有一些属性的解释