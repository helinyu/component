// SDWebImageManager
// 图片的管理类
//  这里面就调用了加载图片的方法了； 
//  我们经常会使用到UIimageView 直接设置网络的url来设置图片； 


ypedef void(^SDExternalCompletionBlock)(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL);

typedef void(^SDInternalCompletionBlock)(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL);

//  一个合并操作代表魂村和加载的操作； 可以使用它取消或者加载
//  其实这个就是包括这两个操作对象
@interface SDWebImageCombinedOperation : NSObject <SDWebImageOperation>

//   取消当前的操作， 包括缓存和下载程序
- (void)cancel;

//   缓存操作
@property (strong, nonatomic, nullable, readonly) id<SDWebImageOperation> cacheOperation;

//  加载的操作（eg: 下载操作）
@property (strong, nonatomic, nullable, readonly) id<SDWebImageOperation> loaderOperation;

@end


@class SDWebImageManager;

//   管理器的代理接口
@protocol SDWebImageManagerDelegate <NSObject>

@optional

//  表示哪些需要下载，如果在缓存中没有的时候
// return NO, 去阻止图片下载如果在缓存中丢失了的话， 如果没有实现， YES是被实现的， 也就是默认是YES
- (BOOL)imageManager:(nonnull SDWebImageManager *)imageManager shouldDownloadImageForURL:(nonnull NSURL *)imageURL;

//   控制复杂的逻辑去表示失败的urls当下载错误产生的时候
//  如果delegate 实现了这个方法， 我们将不使用内置的方式去根据错误码表示url是错误的
//   是否终端错误， YES： 表示记录了url错位失败的
- (BOOL)imageManager:(nonnull SDWebImageManager *)imageManager shouldBlockFailedURL:(nonnull NSURL *)imageURL withError:(nonnull NSError *)error;

@end

//   图片管理器
//  这个类是在类似UIImageView+WebCache 这种分类的底层
//  绑定了异步下载（SDWebImageDownloader）和图片的缓存（SDImageCache）
//  你可以直接遍历的将网上的图片下载并缓存在另外一个除了UIView的类上下文中 （也就是我们不是缓存在UIView中）
/* 使用的基本的例子
SDWebImageManager *manager = [SDWebImageManager sharedManager];
[manager loadImageWithURL:imageURL
                  options:0
                 progress:nil
                completed:^(UIImage *image, NSData *data, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    if (image) {
                        // do something with image
                    }
                }];
*/

@interface SDWebImageManager : NSObject

//  默nil
@property (weak, nonatomic, nullable) id <SDWebImageManagerDelegate> delegate; // 代理
@property (strong, nonatomic, readonly, nonnull) id<SDImageCache> imageCache; //   图片缓存的管理器
@property (strong, nonatomic, readonly, nonnull) id<SDImageLoader> imageLoader; // 图片加载器

//  图片变换对于管理器， 它被用来变换图片在图片下载完成之后，并且下载变换图片去下载， 查看 SDImageTransformer
//  默认是nil， 以为没有变换提供
// 注意： 这个将会影响到所有的加载请求对于这个管理器的提供的下载， 但是， 你能够通过SDWebImageContextImageTransformer 在上下文参数中显示使用转换器
@property (strong, nonatomic, nullable) id<SDImageTransformer> transformer;

//  缓存key的过滤器
/*
 SDWebImageManager.sharedManager.cacheKeyFilter =[SDWebImageCacheKeyFilter cacheKeyFilterWithBlock:^NSString * _Nullable(NSURL * _Nonnull url) {
    url = [[NSURL alloc] initWithScheme:url.scheme host:url.host path:url.path];
    return [url absoluteString];
 }];
*/ 
// 缓存过滤器， 是用来转换一个url编程一个缓存key，
@property (nonatomic, strong, nullable) id<SDWebImageCacheKeyFilter> cacheKeyFilter; // 缓存key的过滤器

// 用来转化解码图片， 元下载数据，到真实数据被用来存储到硬盘缓存中。如果你返回nil， 意味这从一个图片实例中产生数据， eg：`SDImageCache`
// 例如： 如果你讲webp图片解码的时候存在耗时的 问题提， 如不过你从缓存中还是需要解码， 那么你可以考虑将解码的图片编码成为jpeg/png 的格式缓存到图片替换下载数据；
// 注意： image是不空的， 如果将一个图片转换为另外一种格式， 数据可能是编程nil， 注意这个问题
// 注意：这个方法被从一个全局队列中调用为了不阻塞主线程；
//  默认的值是nil， 因为我们将下载的数据缓存到磁盘
// 
/*
 SDWebImageManager.sharedManager.cacheSerializer = [SDWebImageCacheSerializer cacheSerializerWithBlock:^NSData * _Nullable(UIImage * _Nonnull image, NSData * _Nullable data, NSURL * _Nullable imageURL) {
    SDImageFormat format = [NSData sd_imageFormatForImageData:data];
    switch (format) {
        case SDImageFormatWebP:
            return image.images ? data : nil;
        default:
            return data;
    }
}];
*/ 
@property (nonatomic, strong, nullable) id<SDWebImageCacheSerializer> cacheSerializer;  // 缓存系列化

//  选项处理器
//  选项处理器被使用， 有一个全局控制对于所有图片的选项和上下文的选项对于当前的管理器；
//  注意： 你使用了 `transformer`, `cacheKeyFilter` or `cacheSerializer` 在管理器中， 
//  这个输入的上下文选项已经被用于这些属性在传递之前， 这个选项处理器是一个号的替换对于这些属性用于公共使用；
//  eg： 如果能能够控制全局选项，基于url和原始的额上下文选项， 如下面的例子：
/*
 SDWebImageManager.sharedManager.optionsProcessor = [SDWebImageOptionsProcessor optionsProcessorWithBlock:^SDWebImageOptionsResult * _Nullable(NSURL * _Nullable url, SDWebImageOptions options, SDWebImageContext * _Nullable context) {
     // Only do animation on `SDAnimatedImageView`
     if (!context[SDWebImageContextAnimatedImageClass]) {
        options |= SDWebImageDecodeFirstFrameOnly;
     }
     // Do not force decode for png url
     if ([url.lastPathComponent isEqualToString:@"png"]) {
        options |= SDWebImageAvoidDecodeImage;
     }
     // Always use screen scale factor
     SDWebImageMutableContext *mutableContext = [NSDictionary dictionaryWithDictionary:context];
     mutableContext[SDWebImageContextImageScaleFactor] = @(UIScreen.mainScreen.scale);
     context = [mutableContext copy];
 
     return [[SDWebImageOptionsResult alloc] initWithOptions:options context:context];
 }];
*/ 
@property (nonatomic, strong, nullable) id<SDWebImageOptionsProcessor> optionsProcessor;

//   检查一个或更多的操作是否在运行
@property (nonatomic, assign, readonly, getter=isRunning) BOOL running;

//  默认的缓存对象， 以为这使用SDImageCache.sharedImageCache
@property (nonatomic, class, nullable) id<SDImageCache> defaultImageCache;

//   默认下载器，意味着使用 SDWebImageDownloader.sharedDownloader
@property (nonatomic, class, nullable) id<SDImageLoader> defaultImageLoader;

//  返回一个全全局的管理器对象
@property (nonatomic, class, readonly, nonnull) SDWebImageManager *sharedManager;


//   允许指定一个缓存对象和一个图片下载器用于图片管理器，  ———— 也就是自定义缓存器和下载器
- (nonnull instancetype)initWithCache:(nonnull id<SDImageCache>)cache loader:(nonnull id<SDImageLoader>)loader NS_DESIGNATED_INITIALIZER;

//  同归一个url下载图片如果这个图片还没有缓存，否则返回缓存的版本
// url: 图片url， options：指定请求的选项 ， progressBlock 进度的回调   completedBlock：完成的回调  context：包括不同的选项去执行指定的变化和进度， 查看SDWebImageContextOption 这个额外的对象是options 枚举没有的
//  completedBlock
- (nullable SDWebImageCombinedOperation *)loadImageWithURL:(nullable NSURL *)url
                                                   options:(SDWebImageOptions)options
                                                  progress:(nullable SDImageLoaderProgressBlock)progressBlock
                                                 completed:(nonnull SDInternalCompletionBlock)completedBlock;
- (nullable SDWebImageCombinedOperation *)loadImageWithURL:(nullable NSURL *)url
                                                   options:(SDWebImageOptions)options
                                                   context:(nullable SDWebImageContext *)context
                                                  progress:(nullable SDImageLoaderProgressBlock)progressBlock
                                                 completed:(nonnull SDInternalCompletionBlock)completedBlock;

//  取消所有的操作
- (void)cancelAll;

//  从失败的黑名单中移除url
- (void)removeFailedURL:(nonnull NSURL *)url;

//   移除失败的黑名单中所有的url
- (void)removeAllFailedURLs;

//  通过url获取缓存的key，不考虑变换或者缩略图
- (nullable NSString *)cacheKeyForURL:(nullable NSURL *)url;

//  返回一个缓存的key通过给出的url和上下文选项
//  注意：像缩略像素大小和 图片变换将会影响产生缓存key； 使用这个会涉及到上下文关联
- (nullable NSString *)cacheKeyForURL:(nullable NSURL *)url context:(nullable SDWebImageContext *)context;

@end


___________________________________________________________________________________________________
.m 文件
___________________________________________________________________________________________________

#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"
#import "UIImage+Metadata.h"
#import "SDAssociatedObject.h"
#import "SDWebImageError.h"
#import "SDInternalMacros.h"

static id<SDImageCache> _defaultImageCache;
static id<SDImageLoader> _defaultImageLoader;

@interface SDWebImageCombinedOperation ()

@property (assign, nonatomic, getter = isCancelled) BOOL cancelled;
@property (strong, nonatomic, readwrite, nullable) id<SDWebImageOperation> loaderOperation;
@property (strong, nonatomic, readwrite, nullable) id<SDWebImageOperation> cacheOperation;
@property (weak, nonatomic, nullable) SDWebImageManager *manager;

@end

@interface SDWebImageManager () {
    SD_LOCK_DECLARE(_failedURLsLock); // a lock to keep the access to `failedURLs` thread-safe
    SD_LOCK_DECLARE(_runningOperationsLock); // a lock to keep the access to `runningOperations` thread-safe
}

@property (strong, nonatomic, readwrite, nonnull) SDImageCache *imageCache;
@property (strong, nonatomic, readwrite, nonnull) id<SDImageLoader> imageLoader;
@property (strong, nonatomic, nonnull) NSMutableSet<NSURL *> *failedURLs;
@property (strong, nonatomic, nonnull) NSMutableSet<SDWebImageCombinedOperation *> *runningOperations;

@end

@implementation SDWebImageManager

+ (id<SDImageCache>)defaultImageCache {
    return _defaultImageCache;
}

+ (void)setDefaultImageCache:(id<SDImageCache>)defaultImageCache {
    if (defaultImageCache && ![defaultImageCache conformsToProtocol:@protocol(SDImageCache)]) {
        return;
    }
    _defaultImageCache = defaultImageCache;
}

+ (id<SDImageLoader>)defaultImageLoader {
    return _defaultImageLoader;
}

+ (void)setDefaultImageLoader:(id<SDImageLoader>)defaultImageLoader {
    if (defaultImageLoader && ![defaultImageLoader conformsToProtocol:@protocol(SDImageLoader)]) {
        return;
    }
    _defaultImageLoader = defaultImageLoader;
}

+ (nonnull instancetype)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (nonnull instancetype)init {
    id<SDImageCache> cache = [[self class] defaultImageCache];
    if (!cache) {
        cache = [SDImageCache sharedImageCache];
    }
    id<SDImageLoader> loader = [[self class] defaultImageLoader];
    if (!loader) {
        loader = [SDWebImageDownloader sharedDownloader];
    }
    return [self initWithCache:cache loader:loader];
}

- (nonnull instancetype)initWithCache:(nonnull id<SDImageCache>)cache loader:(nonnull id<SDImageLoader>)loader {
    if ((self = [super init])) {
        _imageCache = cache;
        _imageLoader = loader;
        _failedURLs = [NSMutableSet new];
        SD_LOCK_INIT(_failedURLsLock);
        _runningOperations = [NSMutableSet new];
        SD_LOCK_INIT(_runningOperationsLock);
    }
    return self;
}

- (nullable NSString *)cacheKeyForURL:(nullable NSURL *)url {
    if (!url) {
        return @"";
    }
    
    NSString *key;
    // Cache Key Filter
    id<SDWebImageCacheKeyFilter> cacheKeyFilter = self.cacheKeyFilter;
    if (cacheKeyFilter) {
        key = [cacheKeyFilter cacheKeyForURL:url];
    } else {
        key = url.absoluteString;
    }
    
    return key;
}


//  获取缓存的key通过url和上下文
//  1）如果在上下文中有缓存过滤器， 就使用上下文中的key，
//  2）如果上下文中没有缓存过滤器的key， 就使用我们cacheKeyFilter （缓存key过滤器）
//  3）判断缩略图的变换， 如果缩略图有， 就拼接上缩略图组合成为一个新的key（缩略图是变换中的一个特殊的key）
//  4）如果还有一些变换的key， 那么就拼接这个变换的key
- (nullable NSString *)cacheKeyForURL:(nullable NSURL *)url context:(nullable SDWebImageContext *)context {
    if (!url) {
        return @"";
    }
    
    NSString *key;
    // Cache Key Filter
    id<SDWebImageCacheKeyFilter> cacheKeyFilter = self.cacheKeyFilter;  // 缓存过滤器 ， 应该是一个拦截的效果
    if (context[SDWebImageContextCacheKeyFilter]) {//  上下呢是针对拦截器更急个性化的设置cachekey
        cacheKeyFilter = context[SDWebImageContextCacheKeyFilter];
    }
    if (cacheKeyFilter) {
        key = [cacheKeyFilter cacheKeyForURL:url];
    } else {
        key = url.absoluteString;
    }
    
    // Thumbnail Key Appending , 应该是拼接上缩略图的内容了
    NSValue *thumbnailSizeValue = context[SDWebImageContextImageThumbnailPixelSize];
    if (thumbnailSizeValue != nil) {
        CGSize thumbnailSize = CGSizeZero;
#if SD_MAC
        thumbnailSize = thumbnailSizeValue.sizeValue;
#else
        thumbnailSize = thumbnailSizeValue.CGSizeValue;
#endif
        BOOL preserveAspectRatio = YES;
        NSNumber *preserveAspectRatioValue = context[SDWebImageContextImagePreserveAspectRatio]; // 图片保持的比例大小
        if (preserveAspectRatioValue != nil) {
            preserveAspectRatio = preserveAspectRatioValue.boolValue;
        }
        key = SDThumbnailedKeyForKey(key, thumbnailSize, preserveAspectRatio); // 获取缩略图的cachekey
    }
    
    // Transformer Key Appending
    id<SDImageTransformer> transformer = self.transformer; // 这个有变换的凭借
    if (context[SDWebImageContextImageTransformer]) {
        transformer = context[SDWebImageContextImageTransformer];
        if (![transformer conformsToProtocol:@protocol(SDImageTransformer)]) {
            transformer = nil;
        }
    }
    if (transformer) {
        key = SDTransformedKeyForKey(key, transformer.transformerKey);
    }
    
    return key;
}

- (SDWebImageCombinedOperation *)loadImageWithURL:(NSURL *)url options:(SDWebImageOptions)options progress:(SDImageLoaderProgressBlock)progressBlock completed:(SDInternalCompletionBlock)completedBlock {
    return [self loadImageWithURL:url options:options context:nil progress:progressBlock completed:completedBlock];
}
- (SDWebImageCombinedOperation *)loadImageWithURL:(nullable NSURL *)url
                                          options:(SDWebImageOptions)options
                                          context:(nullable SDWebImageContext *)context
                                         progress:(nullable SDImageLoaderProgressBlock)progressBlock
                                        completed:(nonnull SDInternalCompletionBlock)completedBlock {
    // Invoking this method without a completedBlock is pointless 也就是我们这个方法使用，就是要有回调回去的内容
    NSAssert(completedBlock != nil, @"If you mean to prefetch the image, use -[SDWebImagePrefetcher prefetchURLs] instead");

    // Very common mistake is to send the URL using NSString object instead of NSURL. For some strange reason, Xcode won't
    // throw any warning for this type mismatch. Here we failsafe this error by allowing URLs to be passed as NSString.
    if ([url isKindOfClass:NSString.class]) { // 因为xcode中没有报错如果使用string替换掉url， 这里是错误返券处理
        url = [NSURL URLWithString:(NSString *)url];
    }

    // Prevents app crashing on argument type error like sending NSNull instead of NSURL
    if (![url isKindOfClass:NSURL.class]) {
        url = nil;
    }
    //  上面是安全处理

    SDWebImageCombinedOperation *operation = [SDWebImageCombinedOperation new];
    operation.manager = self;

    BOOL isFailedUrl = NO;
    if (url) {
        SD_LOCK(_failedURLsLock);
        isFailedUrl = [self.failedURLs containsObject:url];
        SD_UNLOCK(_failedURLsLock);
    }

//  判断这种错误的代码情况， 1、 没有长度、2、在失败的url黑名单里面， 并且没有尝试失败的重试的策略， 就直接回调错误的处理
    if (url.absoluteString.length == 0 || (!(options & SDWebImageRetryFailed) && isFailedUrl)) {
        NSString *description = isFailedUrl ? @"Image url is blacklisted" : @"Image url is nil";
        NSInteger code = isFailedUrl ? SDWebImageErrorBlackListed : SDWebImageErrorInvalidURL;
        [self callCompletionBlockForOperation:operation completion:completedBlock error:[NSError errorWithDomain:SDWebImageErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey : description}] url:url];
        return operation;
    }

    SD_LOCK(_runningOperationsLock);
    [self.runningOperations addObject:operation]; // 运行的合并的操作
    SD_UNLOCK(_runningOperationsLock);
    
    // Preprocess the options and context arg to decide the final the result for manager
    SDWebImageOptionsResult *result = [self processedResultForURL:url options:options context:context]; // 获取选项的结果
    
    // Start the entry to load image from cache 调用缓存策略和执行操作
    [self callCacheProcessForOperation:operation url:url options:result.options context:result.context progress:progressBlock completed:completedBlock];

    return operation;
}

- (void)cancelAll {
    SD_LOCK(_runningOperationsLock);
    NSSet<SDWebImageCombinedOperation *> *copiedOperations = [self.runningOperations copy];
    SD_UNLOCK(_runningOperationsLock);
    [copiedOperations makeObjectsPerformSelector:@selector(cancel)]; // This will call `safelyRemoveOperationFromRunning:` and remove from the array
}

- (BOOL)isRunning {
    BOOL isRunning = NO;
    SD_LOCK(_runningOperationsLock);
    isRunning = (self.runningOperations.count > 0);
    SD_UNLOCK(_runningOperationsLock);
    return isRunning;
}

- (void)removeFailedURL:(NSURL *)url {
    if (!url) {
        return;
    }
    SD_LOCK(_failedURLsLock);
    [self.failedURLs removeObject:url];
    SD_UNLOCK(_failedURLsLock);
}

- (void)removeAllFailedURLs {
    SD_LOCK(_failedURLsLock);
    [self.failedURLs removeAllObjects];
    SD_UNLOCK(_failedURLsLock);
}

#pragma mark - Private

// Query normal cache process 调用常规的缓存进程
//  缓存的操作
- (void)callCacheProcessForOperation:(nonnull SDWebImageCombinedOperation *)operation
                                 url:(nonnull NSURL *)url
                             options:(SDWebImageOptions)options
                             context:(nullable SDWebImageContext *)context
                            progress:(nullable SDImageLoaderProgressBlock)progressBlock
                           completed:(nullable SDInternalCompletionBlock)completedBlock {
    // Grab the image cache to use
    id<SDImageCache> imageCache;//获取下载对象
    if ([context[SDWebImageContextImageCache] conformsToProtocol:@protocol(SDImageCache)]) {
        imageCache = context[SDWebImageContextImageCache];
    } else {
        imageCache = self.imageCache;
    }
    
    // Get the query cache type  缓存类型
    SDImageCacheType queryCacheType = SDImageCacheTypeAll;
    if (context[SDWebImageContextQueryCacheType]) {
        queryCacheType = [context[SDWebImageContextQueryCacheType] integerValue];
    }
    
    // Check whether we should query cache
    BOOL shouldQueryCache = !SD_OPTIONS_CONTAINS(options, SDWebImageFromLoaderOnly); // 是否需要查询缓存
    if (shouldQueryCache) {
        NSString *key = [self cacheKeyForURL:url context:context];
        //  这个缓存是如何进行处理的？
        @weakify(operation);
        operation.cacheOperation = [imageCache queryImageForKey:key options:options context:context cacheType:queryCacheType completion:^(UIImage * _Nullable cachedImage, NSData * _Nullable cachedData, SDImageCacheType cacheType) {
            @strongify(operation);
            if (!operation || operation.isCancelled) {
                // Image combined operation cancelled by user
                [self callCompletionBlockForOperation:operation completion:completedBlock error:[NSError errorWithDomain:SDWebImageErrorDomain code:SDWebImageErrorCancelled userInfo:@{NSLocalizedDescriptionKey : @"Operation cancelled by user during querying the cache"}] url:url];
                [self safelyRemoveOperationFromRunning:operation];
                return;
            } else if (context[SDWebImageContextImageTransformer] && !cachedImage) {
                // Have a chance to query original cache instead of downloading
                [self callOriginalCacheProcessForOperation:operation url:url options:options context:context progress:progressBlock completed:completedBlock];
                return;
            }
            
            // Continue download process
            [self callDownloadProcessForOperation:operation url:url options:options context:context cachedImage:cachedImage cachedData:cachedData cacheType:cacheType progress:progressBlock completed:completedBlock];
        }];
    } else {
        // Continue download process ， 如果不能够缓存，还是下载
        [self callDownloadProcessForOperation:operation url:url options:options context:context cachedImage:nil cachedData:nil cacheType:SDImageCacheTypeNone progress:progressBlock completed:completedBlock];
    }
}

// Query original cache process
- (void)callOriginalCacheProcessForOperation:(nonnull SDWebImageCombinedOperation *)operation
                                         url:(nonnull NSURL *)url
                                     options:(SDWebImageOptions)options
                                     context:(nullable SDWebImageContext *)context
                                    progress:(nullable SDImageLoaderProgressBlock)progressBlock
                                   completed:(nullable SDInternalCompletionBlock)completedBlock {
    // Grab the image cache to use
    id<SDImageCache> imageCache;
    if ([context[SDWebImageContextImageCache] conformsToProtocol:@protocol(SDImageCache)]) {
        imageCache = context[SDWebImageContextImageCache];
    } else {
        imageCache = self.imageCache;
    }
    
    // Get the original query cache type
    SDImageCacheType originalQueryCacheType = SDImageCacheTypeNone;
    if (context[SDWebImageContextOriginalQueryCacheType]) {
        originalQueryCacheType = [context[SDWebImageContextOriginalQueryCacheType] integerValue];
    }
    
    // Check whether we should query original cache
    BOOL shouldQueryOriginalCache = (originalQueryCacheType != SDImageCacheTypeNone);
    if (shouldQueryOriginalCache) {
        // Change originContext to mutable
        SDWebImageMutableContext * __block originContext;
        if (context) {
            originContext = [context mutableCopy];
        } else {
            originContext = [NSMutableDictionary dictionary];
        }
        
        // Disable transformer for cache key generation
        id<SDImageTransformer> transformer = originContext[SDWebImageContextImageTransformer];
        originContext[SDWebImageContextImageTransformer] = [NSNull null];
        
        NSString *key = [self cacheKeyForURL:url context:originContext];
        @weakify(operation);
        operation.cacheOperation = [imageCache queryImageForKey:key options:options context:context cacheType:originalQueryCacheType completion:^(UIImage * _Nullable cachedImage, NSData * _Nullable cachedData, SDImageCacheType cacheType) {
            @strongify(operation);
            if (!operation || operation.isCancelled) {
                // Image combined operation cancelled by user
                [self callCompletionBlockForOperation:operation completion:completedBlock error:[NSError errorWithDomain:SDWebImageErrorDomain code:SDWebImageErrorCancelled userInfo:@{NSLocalizedDescriptionKey : @"Operation cancelled by user during querying the cache"}] url:url];
                [self safelyRemoveOperationFromRunning:operation];
                return;
            }
            
            // Add original transformer
            if (transformer) {
                originContext[SDWebImageContextImageTransformer] = transformer;
            }
            
            // Use the store cache process instead of downloading, and ignore .refreshCached option for now
            [self callStoreCacheProcessForOperation:operation url:url options:options context:context downloadedImage:cachedImage downloadedData:cachedData finished:YES progress:progressBlock completed:completedBlock];
            
            [self safelyRemoveOperationFromRunning:operation];
        }];
    } else {
        // Continue download process
        [self callDownloadProcessForOperation:operation url:url options:options context:context cachedImage:nil cachedData:nil cacheType:originalQueryCacheType progress:progressBlock completed:completedBlock];
    }
}

//  下载的的操作
- (void)callDownloadProcessForOperation:(nonnull SDWebImageCombinedOperation *)operation
                                    url:(nonnull NSURL *)url
                                options:(SDWebImageOptions)options
                                context:(SDWebImageContext *)context
                            cachedImage:(nullable UIImage *)cachedImage
                             cachedData:(nullable NSData *)cachedData
                              cacheType:(SDImageCacheType)cacheType
                               progress:(nullable SDImageLoaderProgressBlock)progressBlock
                              completed:(nullable SDInternalCompletionBlock)completedBlock {
    // Grab the image loader to use
    id<SDImageLoader> imageLoader;
    if ([context[SDWebImageContextImageLoader] conformsToProtocol:@protocol(SDImageLoader)]) {
        imageLoader = context[SDWebImageContextImageLoader];
    } else {
        imageLoader = self.imageLoader;
    }
    
    // Check whether we should download image from network
    BOOL shouldDownload = !SD_OPTIONS_CONTAINS(options, SDWebImageFromCacheOnly);
    shouldDownload &= (!cachedImage || options & SDWebImageRefreshCached);
    shouldDownload &= (![self.delegate respondsToSelector:@selector(imageManager:shouldDownloadImageForURL:)] || [self.delegate imageManager:self shouldDownloadImageForURL:url]);
    if ([imageLoader respondsToSelector:@selector(canRequestImageForURL:options:context:)]) {
        shouldDownload &= [imageLoader canRequestImageForURL:url options:options context:context];
    } else {
        shouldDownload &= [imageLoader canRequestImageForURL:url];
    }
    if (shouldDownload) {
        if (cachedImage && options & SDWebImageRefreshCached) {
            // If image was found in the cache but SDWebImageRefreshCached is provided, notify about the cached image
            // AND try to re-download it in order to let a chance to NSURLCache to refresh it from server.
            [self callCompletionBlockForOperation:operation completion:completedBlock image:cachedImage data:cachedData error:nil cacheType:cacheType finished:YES url:url];
            // Pass the cached image to the image loader. The image loader should check whether the remote image is equal to the cached image.
            SDWebImageMutableContext *mutableContext;
            if (context) {
                mutableContext = [context mutableCopy];
            } else {
                mutableContext = [NSMutableDictionary dictionary];
            }
            mutableContext[SDWebImageContextLoaderCachedImage] = cachedImage;
            context = [mutableContext copy];
        }
        
        @weakify(operation);
        operation.loaderOperation = [imageLoader requestImageWithURL:url options:options context:context progress:progressBlock completed:^(UIImage *downloadedImage, NSData *downloadedData, NSError *error, BOOL finished) {
            @strongify(operation);
            if (!operation || operation.isCancelled) {
                // Image combined operation cancelled by user
                [self callCompletionBlockForOperation:operation completion:completedBlock error:[NSError errorWithDomain:SDWebImageErrorDomain code:SDWebImageErrorCancelled userInfo:@{NSLocalizedDescriptionKey : @"Operation cancelled by user during sending the request"}] url:url];
            } else if (cachedImage && options & SDWebImageRefreshCached && [error.domain isEqualToString:SDWebImageErrorDomain] && error.code == SDWebImageErrorCacheNotModified) {
                // Image refresh hit the NSURLCache cache, do not call the completion block
            } else if ([error.domain isEqualToString:SDWebImageErrorDomain] && error.code == SDWebImageErrorCancelled) {
                // Download operation cancelled by user before sending the request, don't block failed URL
                [self callCompletionBlockForOperation:operation completion:completedBlock error:error url:url];
            } else if (error) {
                [self callCompletionBlockForOperation:operation completion:completedBlock error:error url:url];
                BOOL shouldBlockFailedURL = [self shouldBlockFailedURLWithURL:url error:error options:options context:context];
                
                if (shouldBlockFailedURL) {
                    SD_LOCK(self->_failedURLsLock);
                    [self.failedURLs addObject:url];
                    SD_UNLOCK(self->_failedURLsLock);
                }
            } else {
                if ((options & SDWebImageRetryFailed)) {
                    SD_LOCK(self->_failedURLsLock);
                    [self.failedURLs removeObject:url];
                    SD_UNLOCK(self->_failedURLsLock);
                }
                // Continue store cache process
                [self callStoreCacheProcessForOperation:operation url:url options:options context:context downloadedImage:downloadedImage downloadedData:downloadedData finished:finished progress:progressBlock completed:completedBlock];
            }
            
            if (finished) {
                [self safelyRemoveOperationFromRunning:operation];
            }
        }];
    } else if (cachedImage) {
        [self callCompletionBlockForOperation:operation completion:completedBlock image:cachedImage data:cachedData error:nil cacheType:cacheType finished:YES url:url];
        [self safelyRemoveOperationFromRunning:operation];
    } else {
        // Image not in cache and download disallowed by delegate
        [self callCompletionBlockForOperation:operation completion:completedBlock image:nil data:nil error:nil cacheType:SDImageCacheTypeNone finished:YES url:url];
        [self safelyRemoveOperationFromRunning:operation];
    }
}

// Store cache process
- (void)callStoreCacheProcessForOperation:(nonnull SDWebImageCombinedOperation *)operation
                                      url:(nonnull NSURL *)url
                                  options:(SDWebImageOptions)options
                                  context:(SDWebImageContext *)context
                          downloadedImage:(nullable UIImage *)downloadedImage
                           downloadedData:(nullable NSData *)downloadedData
                                 finished:(BOOL)finished
                                 progress:(nullable SDImageLoaderProgressBlock)progressBlock
                                completed:(nullable SDInternalCompletionBlock)completedBlock {
    // the target image store cache type
    SDImageCacheType storeCacheType = SDImageCacheTypeAll;
    if (context[SDWebImageContextStoreCacheType]) {
        storeCacheType = [context[SDWebImageContextStoreCacheType] integerValue];
    }
    // the original store image cache type
    SDImageCacheType originalStoreCacheType = SDImageCacheTypeNone;
    if (context[SDWebImageContextOriginalStoreCacheType]) {
        originalStoreCacheType = [context[SDWebImageContextOriginalStoreCacheType] integerValue];
    }
    // origin cache key
    SDWebImageMutableContext *originContext = [context mutableCopy];
    // disable transformer for cache key generation
    originContext[SDWebImageContextImageTransformer] = [NSNull null];
    NSString *key = [self cacheKeyForURL:url context:originContext];
    id<SDImageTransformer> transformer = context[SDWebImageContextImageTransformer];
    if (![transformer conformsToProtocol:@protocol(SDImageTransformer)]) {
        transformer = nil;
    }
    id<SDWebImageCacheSerializer> cacheSerializer = context[SDWebImageContextCacheSerializer];
    
    BOOL shouldTransformImage = downloadedImage && transformer;
    shouldTransformImage = shouldTransformImage && (!downloadedImage.sd_isAnimated || (options & SDWebImageTransformAnimatedImage));
    shouldTransformImage = shouldTransformImage && (!downloadedImage.sd_isVector || (options & SDWebImageTransformVectorImage));
    BOOL shouldCacheOriginal = downloadedImage && finished;
    
    // if available, store original image to cache
    if (shouldCacheOriginal) {
        // normally use the store cache type, but if target image is transformed, use original store cache type instead
        SDImageCacheType targetStoreCacheType = shouldTransformImage ? originalStoreCacheType : storeCacheType;
        if (cacheSerializer && (targetStoreCacheType == SDImageCacheTypeDisk || targetStoreCacheType == SDImageCacheTypeAll)) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                @autoreleasepool {
                    NSData *cacheData = [cacheSerializer cacheDataWithImage:downloadedImage originalData:downloadedData imageURL:url];
                    [self storeImage:downloadedImage imageData:cacheData forKey:key cacheType:targetStoreCacheType options:options context:context completion:^{
                        // Continue transform process
                        [self callTransformProcessForOperation:operation url:url options:options context:context originalImage:downloadedImage originalData:downloadedData finished:finished progress:progressBlock completed:completedBlock];
                    }];
                }
            });
        } else {
            [self storeImage:downloadedImage imageData:downloadedData forKey:key cacheType:targetStoreCacheType options:options context:context completion:^{
                // Continue transform process
                [self callTransformProcessForOperation:operation url:url options:options context:context originalImage:downloadedImage originalData:downloadedData finished:finished progress:progressBlock completed:completedBlock];
            }];
        }
    } else {
        // Continue transform process
        [self callTransformProcessForOperation:operation url:url options:options context:context originalImage:downloadedImage originalData:downloadedData finished:finished progress:progressBlock completed:completedBlock];
    }
}

// Transform process
//  有关的图片变换的操作
- (void)callTransformProcessForOperation:(nonnull SDWebImageCombinedOperation *)operation
                                     url:(nonnull NSURL *)url
                                 options:(SDWebImageOptions)options
                                 context:(SDWebImageContext *)context
                           originalImage:(nullable UIImage *)originalImage
                            originalData:(nullable NSData *)originalData
                                finished:(BOOL)finished
                                progress:(nullable SDImageLoaderProgressBlock)progressBlock
                               completed:(nullable SDInternalCompletionBlock)completedBlock {
    // the target image store cache type
    SDImageCacheType storeCacheType = SDImageCacheTypeAll;
    if (context[SDWebImageContextStoreCacheType]) {
        storeCacheType = [context[SDWebImageContextStoreCacheType] integerValue];
    }
    // transformed cache key
    NSString *key = [self cacheKeyForURL:url context:context];
    id<SDImageTransformer> transformer = context[SDWebImageContextImageTransformer];
    if (![transformer conformsToProtocol:@protocol(SDImageTransformer)]) {
        transformer = nil;
    }
    id<SDWebImageCacheSerializer> cacheSerializer = context[SDWebImageContextCacheSerializer];
    
    BOOL shouldTransformImage = originalImage && transformer;
    shouldTransformImage = shouldTransformImage && (!originalImage.sd_isAnimated || (options & SDWebImageTransformAnimatedImage));
    shouldTransformImage = shouldTransformImage && (!originalImage.sd_isVector || (options & SDWebImageTransformVectorImage));
    // if available, store transformed image to cache
    if (shouldTransformImage) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            @autoreleasepool {
                UIImage *transformedImage = [transformer transformedImageWithImage:originalImage forKey:key];
                if (transformedImage && finished) {
                    BOOL imageWasTransformed = ![transformedImage isEqual:originalImage];
                    NSData *cacheData;
                    // pass nil if the image was transformed, so we can recalculate the data from the image
                    if (cacheSerializer && (storeCacheType == SDImageCacheTypeDisk || storeCacheType == SDImageCacheTypeAll)) {
                        cacheData = [cacheSerializer cacheDataWithImage:transformedImage originalData:(imageWasTransformed ? nil : originalData) imageURL:url];
                    } else {
                        cacheData = (imageWasTransformed ? nil : originalData);
                    }
                    [self storeImage:transformedImage imageData:cacheData forKey:key cacheType:storeCacheType options:options context:context completion:^{
                        [self callCompletionBlockForOperation:operation completion:completedBlock image:transformedImage data:originalData error:nil cacheType:SDImageCacheTypeNone finished:finished url:url];
                    }];
                } else {
                    [self callCompletionBlockForOperation:operation completion:completedBlock image:transformedImage data:originalData error:nil cacheType:SDImageCacheTypeNone finished:finished url:url];
                }
            }
        });
    } else {
        [self callCompletionBlockForOperation:operation completion:completedBlock image:originalImage data:originalData error:nil cacheType:SDImageCacheTypeNone finished:finished url:url];
    }
}

#pragma mark - Helper

//  移除运行中的操作
- (void)safelyRemoveOperationFromRunning:(nullable SDWebImageCombinedOperation*)operation {
    if (!operation) {
        return;
    }
    SD_LOCK(_runningOperationsLock);
    [self.runningOperations removeObject:operation];
    SD_UNLOCK(_runningOperationsLock);
}

//  存储图片
- (void)storeImage:(nullable UIImage *)image
         imageData:(nullable NSData *)data
            forKey:(nullable NSString *)key
         cacheType:(SDImageCacheType)cacheType
           options:(SDWebImageOptions)options
           context:(nullable SDWebImageContext *)context
        completion:(nullable SDWebImageNoParamsBlock)completion {
    id<SDImageCache> imageCache;
    if ([context[SDWebImageContextImageCache] conformsToProtocol:@protocol(SDImageCache)]) {
        imageCache = context[SDWebImageContextImageCache];
    } else {
        imageCache = self.imageCache;
    }
    BOOL waitStoreCache = SD_OPTIONS_CONTAINS(options, SDWebImageWaitStoreCache);
    // Check whether we should wait the store cache finished. If not, callback immediately
    [imageCache storeImage:image imageData:data forKey:key cacheType:cacheType completion:^{
        if (waitStoreCache) {
            if (completion) {
                completion();
            }
        }
    }];
    if (!waitStoreCache) {
        if (completion) {
            completion();
        }
    }
}

- (void)callCompletionBlockForOperation:(nullable SDWebImageCombinedOperation*)operation
                             completion:(nullable SDInternalCompletionBlock)completionBlock
                                  error:(nullable NSError *)error
                                    url:(nullable NSURL *)url {
    [self callCompletionBlockForOperation:operation completion:completionBlock image:nil data:nil error:error cacheType:SDImageCacheTypeNone finished:YES url:url];
}

- (void)callCompletionBlockForOperation:(nullable SDWebImageCombinedOperation*)operation
                             completion:(nullable SDInternalCompletionBlock)completionBlock
                                  image:(nullable UIImage *)image
                                   data:(nullable NSData *)data
                                  error:(nullable NSError *)error
                              cacheType:(SDImageCacheType)cacheType
                               finished:(BOOL)finished
                                    url:(nullable NSURL *)url {
    dispatch_main_async_safe(^{
        if (completionBlock) {
            completionBlock(image, data, error, cacheType, finished, url);
        }
    });
}

- (BOOL)shouldBlockFailedURLWithURL:(nonnull NSURL *)url
                              error:(nonnull NSError *)error
                            options:(SDWebImageOptions)options
                            context:(nullable SDWebImageContext *)context {
    id<SDImageLoader> imageLoader;
    if ([context[SDWebImageContextImageLoader] conformsToProtocol:@protocol(SDImageLoader)]) {
        imageLoader = context[SDWebImageContextImageLoader];
    } else {
        imageLoader = self.imageLoader;
    }
    // Check whether we should block failed url
    BOOL shouldBlockFailedURL;
    if ([self.delegate respondsToSelector:@selector(imageManager:shouldBlockFailedURL:withError:)]) {
        shouldBlockFailedURL = [self.delegate imageManager:self shouldBlockFailedURL:url withError:error];
    } else {
        if ([imageLoader respondsToSelector:@selector(shouldBlockFailedURLWithURL:error:options:context:)]) {
            shouldBlockFailedURL = [imageLoader shouldBlockFailedURLWithURL:url error:error options:options context:context];
        } else {
            shouldBlockFailedURL = [imageLoader shouldBlockFailedURLWithURL:url error:error];
        }
    }
    
    return shouldBlockFailedURL;
}

//  解析选项的结果 ， 另外的一个类里面， 这个是可以去处理的
//  其实就是多种类型的选项组合
- (SDWebImageOptionsResult *)processedResultForURL:(NSURL *)url options:(SDWebImageOptions)options context:(SDWebImageContext *)context {
    SDWebImageOptionsResult *result;
    SDWebImageMutableContext *mutableContext = [SDWebImageMutableContext dictionary];
    
    // Image Transformer from manager
    //  图片变换
    if (!context[SDWebImageContextImageTransformer]) {
        id<SDImageTransformer> transformer = self.transformer;
        [mutableContext setValue:transformer forKey:SDWebImageContextImageTransformer];
    }
    // Cache key filter from manager
    //  缓存key  过滤器
    if (!context[SDWebImageContextCacheKeyFilter]) {
        id<SDWebImageCacheKeyFilter> cacheKeyFilter = self.cacheKeyFilter;
        [mutableContext setValue:cacheKeyFilter forKey:SDWebImageContextCacheKeyFilter];
    }
    // Cache serializer from manager
    //  系列化
    if (!context[SDWebImageContextCacheSerializer]) {
        id<SDWebImageCacheSerializer> cacheSerializer = self.cacheSerializer;
        [mutableContext setValue:cacheSerializer forKey:SDWebImageContextCacheSerializer];
    }
    
    if (mutableContext.count > 0) {
        if (context) {
            [mutableContext addEntriesFromDictionary:context];
        }
        context = [mutableContext copy];
    }
    
    // Apply options processor
    if (self.optionsProcessor) {
        result = [self.optionsProcessor processedResultForURL:url options:options context:context];
    }
    if (!result) {
        // Use default options result
        result = [[SDWebImageOptionsResult alloc] initWithOptions:options context:context];
    }
    
    return result;
}

@end


@implementation SDWebImageCombinedOperation

//  取消操作
- (void)cancel {
    @synchronized(self) {
        if (self.isCancelled) {
            return;
        }
        self.cancelled = YES;
        if (self.cacheOperation) {
            [self.cacheOperation cancel];
            self.cacheOperation = nil;
        }
        if (self.loaderOperation) {
            [self.loaderOperation cancel];
            self.loaderOperation = nil;
        }
        [self.manager safelyRemoveOperationFromRunning:self];
    }
}

@end
