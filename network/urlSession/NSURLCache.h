//  URL 缓存

#import <Foundation/NSObject.h>

NS_ASSUME_NONNULL_BEGIN

// 缓存存储策略
typedef NS_ENUM(NSUInteger, NSURLCacheStoragePolicy)
{
    NSURLCacheStorageAllowed, // 允许存储
    NSURLCacheStorageAllowedInMemoryOnly, // 只是内存存储
    NSURLCacheStorageNotAllowed, // 不允许
};



/*!
    @class NSCachedURLResponse
    NSCachedURLResponse is a class whose objects functions as a wrapper for
    objects that are stored in the framework's caching system. 
    It is used to maintain characteristics and attributes of a cached 
    object. 
*/
API_AVAILABLE(macos(10.2), ios(2.0), watchos(2.0), tvos(9.0))
@interface NSCachedURLResponse : NSObject <NSSecureCoding, NSCopying>
{
    @private
    NSCachedURLResponseInternal *_internal;
}

/*! 
    @method initWithResponse:data
    @abstract Initializes an NSCachedURLResponse with the given
    response and data.
    @discussion A default NSURLCacheStoragePolicy is used for
    NSCachedURLResponse objects initialized with this method:
    NSURLCacheStorageAllowed.
    @param response a NSURLResponse object.
    @param data an NSData object representing the URL content
    corresponding to the given response.
    @result an initialized NSCachedURLResponse.
*/
- (instancetype)initWithResponse:(NSURLResponse *)response data:(NSData *)data;

/*! 
    @method initWithResponse:data:userInfo:storagePolicy:
    @abstract Initializes an NSCachedURLResponse with the given
    response, data, user-info dictionary, and storage policy.
    @param response a NSURLResponse object.
    @param data an NSData object representing the URL content
    corresponding to the given response.
    @param userInfo a dictionary user-specified information to be
    stored with the NSCachedURLResponse.
    @param storagePolicy an NSURLCacheStoragePolicy constant.
    @result an initialized NSCachedURLResponse.
*/
- (instancetype)initWithResponse:(NSURLResponse *)response data:(NSData *)data userInfo:(nullable NSDictionary *)userInfo storagePolicy:(NSURLCacheStoragePolicy)storagePolicy;

/*!
    @abstract Returns the response wrapped by this instance. 
    @result The response wrapped by this instance. 
*/
@property (readonly, copy) NSURLResponse *response;

/*!
    @abstract Returns the data of the receiver. 
    @result The data of the receiver. 
*/
@property (readonly, copy) NSData *data;

/*!
    @abstract Returns the userInfo dictionary of the receiver. 
    @result The userInfo dictionary of the receiver. 
*/
@property (nullable, readonly, copy) NSDictionary *userInfo;

/*!
    @abstract Returns the NSURLCacheStoragePolicy constant of the receiver. 
    @result The NSURLCacheStoragePolicy constant of the receiver. 
*/
@property (readonly) NSURLCacheStoragePolicy storagePolicy;

@end


@class NSURLRequest;
@class NSURLCacheInternal;

API_AVAILABLE(macos(10.2), ios(2.0), watchos(2.0), tvos(9.0))
@interface NSURLCache : NSObject
{
    @private
    NSURLCacheInternal *_internal;
}

/*! 
    @property sharedURLCache
    @abstract Returns the shared NSURLCache instance or
    sets the NSURLCache instance shared by all clients of
    the current process. This will be the new object returned when
    calls to the <tt>sharedURLCache</tt> method are made.
    @discussion Unless set explicitly through a call to
    <tt>+setSharedURLCache:</tt>, this method returns an NSURLCache
    instance created with the following default values:
    <ul>
    <li>Memory capacity: 4 megabytes (4 * 1024 * 1024 bytes)
    <li>Disk capacity: 20 megabytes (20 * 1024 * 1024 bytes)
    <li>Disk path: <nobr>(user home directory)/Library/Caches/(application bundle id)</nobr> 
    </ul>
    <p>Users who do not have special caching requirements or
    constraints should find the default shared cache instance
    acceptable. If this default shared cache instance is not
    acceptable, <tt>+setSharedURLCache:</tt> can be called to set a
    different NSURLCache instance to be returned from this method. 
    Callers should take care to ensure that the setter is called
    at a time when no other caller has a reference to the previously-set 
    shared URL cache. This is to prevent storing cache data from 
    becoming unexpectedly unretrievable.
    @result the shared NSURLCache instance.
*/
//  单例， 有默认的大小
@property (class, strong) NSURLCache *sharedURLCache;

//  初始化一个缓存对象
- (instancetype)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(nullable NSString *)path API_DEPRECATED_WITH_REPLACEMENT("initWithMemoryCapacity:diskCapacity:directoryURL:", macos(10.2, API_TO_BE_DEPRECATED), ios(2.0, API_TO_BE_DEPRECATED), watchos(2.0, API_TO_BE_DEPRECATED), tvos(9.0, API_TO_BE_DEPRECATED));
- (instancetype)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity directoryURL:(nullable NSURL *)directoryURL API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0));

//  通过request来获取缓存
- (nullable NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request;

//  存储缓存响应
- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request;


//  删除： request /all/ sinceDate 
- (void)removeCachedResponseForRequest:(NSURLRequest *)request;
- (void)removeAllCachedResponses;
- (void)removeCachedResponsesSinceDate:(NSDate *)date API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));


@property NSUInteger memoryCapacity; //内存能力
@property NSUInteger diskCapacity; // 磁盘能力

@property (readonly) NSUInteger currentMemoryUsage; // 当前内存使用
@property (readonly) NSUInteger currentDiskUsage; // 当前的硬盘存储使用

@end

//  对应的session task进行的缓存存储
@interface NSURLCache (NSURLSessionTaskAdditions)
- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forDataTask:(NSURLSessionDataTask *)dataTask API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));
- (void)getCachedResponseForDataTask:(NSURLSessionDataTask *)dataTask completionHandler:(void (^) (NSCachedURLResponse * _Nullable cachedResponse))completionHandler API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));
- (void)removeCachedResponseForDataTask:(NSURLSessionDataTask *)dataTask API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));
@end

NS_ASSUME_NONNULL_END
