 这个有对应的内容， 实现对应的接口

//  感觉这个分类不是很清晰
typedef NS_OPTIONS(NSUInteger, SDWebImageDownloaderOptions) {
     // 放在了低的队列里面
    SDWebImageDownloaderLowPriority = 1 << 0,

    //   有进度的下载， 显示也是有进度的
    SDWebImageDownloaderProgressiveLoad = 1 << 1,

    //  默认， 请求是阻止NSURLCache的， 使用这个标签，NSURLCache是使用默认的策略
    //  应该是缓存的， 如果没有设置， 是不缓存的，应该是这样
    SDWebImageDownloaderUseNSURLCache = 1 << 2,

    //  忽略缓存响应数据
    // 这个变量需要和 SDWebImageDownloaderUseNSURLCache 这个一起使用
    // 从cache中读取将会返回nil， 错误码返回SDWebImageErrorCacheNotModified ，也就是不缓存repsonsee， 不可以从缓存中读取response
    SDWebImageDownloaderIgnoreCachedResponse = 1 << 3,

     // 在后台能够继续访问，这样就可以在后台完成瞎子啊， 如果超过系统的后台任务的使劲，将会被取消
    SDWebImageDownloaderContinueInBackground = 1 << 4,

    //  处理cookes存储在NSHTTPCookieStore 中， 通过设置 NSMutableURLRequest.HTTPShouldHandleCookies = YES;
    SDWebImageDownloaderHandleCookies = 1 << 5,

    //   允许不信任ssl验证， 对我们在测试的时候游泳， 在产品中小心使用
    SDWebImageDownloaderAllowInvalidSSLCertificates = 1 << 6,

    //   下载队列中高的权限
    SDWebImageDownloaderHighPriority = 1 << 7,

    //  默认， 图片是按照它们原始的大小进行解耦的，
    //  在iOS中，这个标签将下载图片适配设备内存中宝行的，也就是针对了我们设备进行了缩放比例大小
    //  这个标签无效如果SDWebImageDownloaderAvoidDecodeImage设置， 将会忽略如果SDWebImageDownloaderProgressiveLoad 设置
    SDWebImageDownloaderScaleDownLargeImages = 1 << 8,
    
    //  默认， 我们将解码图片在后后台在缓存询问和从网络下载的时候， 这个能够帮助我们提高性能因为当我们渲染图片到屏幕的时候【因为它需要先解码】但是这个发生在主线程通过Core Animation，
    //  但是，这样可能会提高了内存的占用率， 
    //  如果你想解决内存消耗的问题， 这个选项能够帮助你阻止解码图片
    SDWebImageDownloaderAvoidDecodeImage = 1 << 9,
    
    //  默认，我们解码动画图片， 这个标签能够顾强制只是解码第一帧产生静态图片
    SDWebImageDownloaderDecodeFirstFrameOnly = 1 << 10,

    // 默认，对于SDAnimatedImage ，我们在渲染的时候解码图片减少内存的使用，这个标签触发preloadAllAnimatedImageFrames = YES， 然后从网络下载图片
    SDWebImageDownloaderPreloadAllFrames = 1 << 11,
    
    //  默认， 当你使用SDWebImageContextAnimatedImageClass 上下文（eg: SDAnimatedImageView 被设计为使用SDAnimatedImage）， 我们将依旧时间用UIImage ， 当内存缓存命中， 或者图片解码无效，所以，行为像下面这种情况；
    // 使用这个选项，能够确定我们总是产生图片你提供的类， 如果失败， SDWebImageErrorBadImageData 将会产生
    // 注意： 这个选项不合适SDWebImageDownloaderDecodeFirstFrameOnly， 因为它总是产生一个UIImage/NSImage
    SDWebImageDownloaderMatchAnimatedImageClass = 1 << 12,
};

FOUNDATION_EXPORT NSNotificationName _Nonnull const SDWebImageDownloadStartNotification; // 开始下载的通知
FOUNDATION_EXPORT NSNotificationName _Nonnull const SDWebImageDownloadReceiveResponseNotification; // 接收到的通知
FOUNDATION_EXPORT NSNotificationName _Nonnull const SDWebImageDownloadStopNotification; // 停止的通知 ， 停止是否可以继续从某个地方下载？
FOUNDATION_EXPORT NSNotificationName _Nonnull const SDWebImageDownloadFinishNotification; // 完成的通知

NSNotificationName const SDWebImageDownloadStartNotification = @"SDWebImageDownloadStartNotification";
NSNotificationName const SDWebImageDownloadReceiveResponseNotification = @"SDWebImageDownloadReceiveResponseNotification";
NSNotificationName const SDWebImageDownloadStopNotification = @"SDWebImageDownloadStopNotification";
NSNotificationName const SDWebImageDownloadFinishNotification = @"SDWebImageDownloadFinishNotification";

typedef SDImageLoaderProgressBlock SDWebImageDownloaderProgressBlock;
typedef SDImageLoaderCompletedBlock SDWebImageDownloaderCompletedBlock; // 回调

//   一个token关联每个瞎子啊，能够被用于取消一个下载
@interface SDWebImageDownloadToken : NSObject <SDWebImageOperation>


//   取消当前的下载
- (void)cancel;

//  下载的url
@property (nonatomic, strong, nullable, readonly) NSURL *url;

//  下载的请求
@property (nonatomic, strong, nullable, readonly) NSURLRequest *request;

//  下载的响应
@property (nonatomic, strong, nullable, readonly) NSURLResponse *response;

//  下载的监控， 量度; 以前我们都是自己去监控上行流量和下行流量
@property (nonatomic, strong, nullable, readonly) NSURLSessionTaskMetrics *metrics API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

@end

// 异步下载器 专一、搞笑 的下载图片
@interface SDWebImageDownloader : NSObject

//   只读属性
//  存储所有的设置
// 最多的配置属性支持动态改变在下载期间， 除了一些 像：`sessionConfiguration`, see `SDWebImageDownloaderConfig` 以外
@property (nonatomic, copy, readonly, nonnull) SDWebImageDownloaderConfig *config;

//   请求的修饰
// 在图片下载之前， 修改原来的下载请求
// 这个请求修改方法将会被调用，对于每个图片下载请求， 返回原始请求以为灭有改变， 返回nil将会取消下载请求；
//  默认是nil， 以为没有改变原始下载请求
// 注意： 如果你想修改一个简单的请求， 考虑使用SDWebImageContextDownloadRequestModifier 选项
@property (nonatomic, strong, nullable) id<SDWebImageDownloaderRequestModifier> requestModifier;

//   设置响应修改， 去修改原始下载响应在图片下载期间
// 这个请求修改方法将会对每个响应调用， 返回原始响应以为没有改变， 返回nil，将会标识当前下载被取消了
// 默认是nil， 以为没有改变原始下载的响应
// 注意：你想修改单一的响应，考虑使用SDWebImageContextDownloadResponseModifier 上下文选项
@property (nonatomic, strong, nullable) id<SDWebImageDownloaderResponseModifier> responseModifier;

//  解密器
//  解密器将会在图片解码之前进行解密， 这个鞥能够用于对加密的图像数据，eg： base64 
// 解密器将会被没有下载图片的数据进行调用， 返回原始的图片以为没有改变， 返回nil以为下载失败
// 默认是nil， 以为没有修改原始下载数据
//  注意： 但你使用decryptor ， 渐进下载将会失效， 拒绝数据损坏问题
// 如果你想解密一个简单的下载数据，可以使用SDWebImageContextDownloadDecryptor 选项
@property (nonatomic, strong, nullable) id<SDWebImageDownloaderDecryptor> decryptor;

//   回话配置， 配置用于内部的回话， 如果你想提供一个自定义的sessionConfiguration， 使用SDWebImageDownloaderConfig.sessionConfiguration 和创建一个新的下载实例
//  注意：根据NSURLSession文档，这个是不可变的， 直接改变这个对象是没有小效果的 ， 所以，这个是只读的属性
@property (nonatomic, readonly, nonnull) NSURLSessionConfiguration *sessionConfiguration;

//  gets/sets 下载队列的悬挂状态
@property (nonatomic, assign, getter=isSuspended) BOOL suspended;

//   显示当前下载的数目
@property (nonatomic, assign, readonly) NSUInteger currentDownloadCount;

//   显示全局的下载实例， 当使用`SDWebImageDownloaderConfig.defaultDownloaderConfig`  配置的时候
@property (nonatomic, class, readonly, nonnull) SDWebImageDownloader *sharedDownloader;

//  创建一个指定的下载配置
//  你能够指定回话配置，超市或者操作类通过下载配置
//  config: nil, j就是使用默认的配置
//  返回一个新的下载类
- (nonnull instancetype)initWithConfig:(nullable SDWebImageDownloaderConfig *)config NS_DESIGNATED_INITIALIZER;

//  设置http 头部凭借到没有http请求中
// value =nil 的时候， 就清楚这个field了 ， field就是这个头部的字段
- (void)setValue:(nullable NSString *)value forHTTPHeaderField:(nullable NSString *)field;

//  获取字段的值
- (nullable NSString *)valueForHTTPHeaderField:(nullable NSString *)field;

//   通过url生成一个下载器 
//    代理将会被通知， 如果一张图片下载完成或者一个错误发生 SDWebImageDownloaderDelegate
//  返回的SDWebImageDownloadToken 能够用于取消这个操作
- (nullable SDWebImageDownloadToken *)downloadImageWithURL:(nullable NSURL *)url
                                                 completed:(nullable SDWebImageDownloaderCompletedBlock)completedBlock;
//   这个是上面的一个复杂的版本， 增加了选项
- (nullable SDWebImageDownloadToken *)downloadImageWithURL:(nullable NSURL *)url
                                                   options:(SDWebImageDownloaderOptions)options
                                                  progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                                                 completed:(nullable SDWebImageDownloaderCompletedBlock)completedBlock;

//  增加了上下文的选项
- (nullable SDWebImageDownloadToken *)downloadImageWithURL:(nullable NSURL *)url
                                                   options:(SDWebImageDownloaderOptions)options
                                                   context:(nullable SDWebImageContext *)context
                                                  progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                                                 completed:(nullable SDWebImageDownloaderCompletedBlock)completedBlock;

//  取消所有下载选项
- (void)cancelAllDownloads;

//  将管理回话设置无效， 可选取消没有执行的操作
// 注意：如果你使用自定义下载器替换 全局下载器， 你需要调用这个方法， 当你没有使用它去避免内存泄漏
// cancelPendingOperations 取消的队列
// 注意： 对全局的 （shared downloader ）没有作用
- (void)invalidateSessionAndCancel:(BOOL)cancelPendingOperations;

@end

//  sdWebImageDownLoader 是一个内置的图片下载器， 实现了SDImageLoader 接口， 提供了HTTP/HTTPS/FTP 下载， 或者本地文件的URL使用NSURLSession
//  当值这个下载器列它本省也支持自定义高级用户， 你能够指定operationClass 在下载配置去自定义下载的操作。 看SDWebImageDownloaderOperation
//  如果你想提供一些图片下载器， 超过网络和本地文件，考虑创建你自己自定义类继承SDImageLoader
@interface SDWebImageDownloader (SDImageLoader) <SDImageLoader>

@end


___________________________________________________________________________________________________
.m 文件
____________________________________________________________________________________________________

//  token 是具有唯一性的问题
@interface SDWebImageDownloadToken ()

@property (nonatomic, strong, nullable, readwrite) NSURL *url; // 链接
@property (nonatomic, strong, nullable, readwrite) NSURLRequest *request; // 请求
@property (nonatomic, strong, nullable, readwrite) NSURLResponse *response; // 响应
@property (nonatomic, strong, nullable, readwrite) NSURLSessionTaskMetrics *metrics API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0)); // 监测
@property (nonatomic, weak, nullable, readwrite) id downloadOperationCancelToken; // 下载取消的特肯
@property (nonatomic, weak, nullable) NSOperation<SDWebImageDownloaderOperation> *downloadOperation; // 下载的操作 ，下载的实例
@property (nonatomic, assign, getter=isCancelled) BOOL cancelled; // 取消

@end

//  这个token， 为什么要有这样的一个token的概念，， 
@implementation SDWebImageDownloadToken

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SDWebImageDownloadReceiveResponseNotification object:nil]; // 下载接收到的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SDWebImageDownloadStopNotification object:nil]; // 下载停止的通知
}

- (instancetype)initWithDownloadOperation:(NSOperation<SDWebImageDownloaderOperation> *)downloadOperation {
    self = [super init];
    if (self) {
        _downloadOperation = downloadOperation;

        //  简历通知， 与销毁的时候的对应上
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDidReceiveResponse:) name:SDWebImageDownloadReceiveResponseNotification object:downloadOperation];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDidStop:) name:SDWebImageDownloadStopNotification object:downloadOperation];
    }
    return self;
}

//  接收到下载的通知
- (void)downloadDidReceiveResponse:(NSNotification *)notification {
    NSOperation<SDWebImageDownloaderOperation> *downloadOperation = notification.object;
    if (downloadOperation && downloadOperation == self.downloadOperation) {
        self.response = downloadOperation.response;
    }
}

//  接收到停止下载的通知
- (void)downloadDidStop:(NSNotification *)notification {
    NSOperation<SDWebImageDownloaderOperation> *downloadOperation = notification.object;
    if (downloadOperation && downloadOperation == self.downloadOperation) {
        if ([downloadOperation respondsToSelector:@selector(metrics)]) {
            if (@available(iOS 10.0, tvOS 10.0, macOS 10.12, watchOS 3.0, *)) {
                self.metrics = downloadOperation.metrics; // 为什么是在这里进行监控那个网络？
            }
        }
    }
}

// 取消下载
- (void)cancel {
    @synchronized (self) {
        if (self.isCancelled) {
            return;
        }
        self.cancelled = YES;
        [self.downloadOperation cancel:self.downloadOperationCancelToken];
        self.downloadOperationCancelToken = nil;
    }
}

@end


// ____________________________________________________________________________________________________
// 下载的文件.m 文件
// ____________________________________________________________________________________________________

@interface SDWebImageDownloader () <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (strong, nonatomic, nonnull) NSOperationQueue *downloadQueue; // 下载的队列
@property (strong, nonatomic, nonnull) NSMutableDictionary<NSURL *, NSOperation<SDWebImageDownloaderOperation> *> *URLOperations; // url 和下载的对象的字典
@property (strong, nonatomic, nullable) NSMutableDictionary<NSString *, NSString *> *HTTPHeaders; // 请求头部的字典

// The session in which data tasks will run
@property (strong, nonatomic) NSURLSession *session; // 链接的回话，就是将会运行的会话

@end

@implementation SDWebImageDownloader {
    SD_LOCK_DECLARE(_HTTPHeadersLock); //头部的锁,保证头部的线程安全 
    SD_LOCK_DECLARE(_operationsLock); // 操作的锁,保证线程操作的安全
}

//  初始化的时候处理一些东西 ， 这个有网络的内容
+ (void)initialize {
    // Bind SDNetworkActivityIndicator if available (download it here: http://github.com/rs/SDNetworkActivityIndicator )
    // To use it, just add #import "SDNetworkActivityIndicator.h" in addition to the SDWebImage import
    if (NSClassFromString(@"SDNetworkActivityIndicator")) { //添加这个控件，如果有， 进行处理 , 目前感觉这里基本上是不走了的

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id activityIndicator = [NSClassFromString(@"SDNetworkActivityIndicator") performSelector:NSSelectorFromString(@"sharedActivityIndicator")];
#pragma clang diagnostic pop

        // Remove observer in case it was previously added.
        //  没有注册， 注册不知道这里会不会有问题
        [[NSNotificationCenter defaultCenter] removeObserver:activityIndicator name:SDWebImageDownloadStartNotification object:nil]; // 也就是这个activityIndicator 没有监听这个下载的状态通知
        [[NSNotificationCenter defaultCenter] removeObserver:activityIndicator name:SDWebImageDownloadStopNotification object:nil]; // 当时我在这个文件里面还是没有找到这个内容

        [[NSNotificationCenter defaultCenter] addObserver:activityIndicator
                                                 selector:NSSelectorFromString(@"startActivity")
                                                     name:SDWebImageDownloadStartNotification object:nil]; // 监听这个请求中的状态显示
        [[NSNotificationCenter defaultCenter] addObserver:activityIndicator
                                                 selector:NSSelectorFromString(@"stopActivity")
                                                     name:SDWebImageDownloadStopNotification object:nil]; // 监听网络显示停止的状态
    }
}

+ (nonnull instancetype)sharedDownloader {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

// 要看看SDWebImageDownloaderConfig 这个文件的配置是什么 ， 这个到时候后看是配置了什么
- (nonnull instancetype)init {
    return [self initWithConfig:SDWebImageDownloaderConfig.defaultDownloaderConfig]; // 出事默认的下载配置
}

- (instancetype)initWithConfig:(SDWebImageDownloaderConfig *)config {
    self = [super init];
    if (self) {
        if (!config) {
            config = SDWebImageDownloaderConfig.defaultDownloaderConfig;
        }
        _config = [config copy];
        [_config addObserver:self forKeyPath:NSStringFromSelector(@selector(maxConcurrentDownloads)) options:0 context:SDWebImageDownloaderContext]; // 监听这个对打的下载数量
        _downloadQueue = [NSOperationQueue new];
        _downloadQueue.maxConcurrentOperationCount = _config.maxConcurrentDownloads; // 配置对打的下载数量
        _downloadQueue.name = @"com.hackemist.SDWebImageDownloader"; // 下载的队列的名字
        _URLOperations = [NSMutableDictionary new]; // url的操作
        NSMutableDictionary<NSString *, NSString *> *headerDictionary = [NSMutableDictionary dictionary]; // 头部字典初始化
        NSString *userAgent = nil; // 用户信息
#if SD_UIKIT
        // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
        userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]]; // 获取app信息以及设备的有关信心作为用户端
#elif SD_WATCH
        // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
        userAgent = [NSString stringWithFormat:@"%@/%@ (%@; watchOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[WKInterfaceDevice currentDevice] model], [[WKInterfaceDevice currentDevice] systemVersion], [[WKInterfaceDevice currentDevice] screenScale]];
#elif SD_MAC
        userAgent = [NSString stringWithFormat:@"%@/%@ (Mac OS X %@)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[NSProcessInfo processInfo] operatingSystemVersionString]];
#endif
        if (userAgent) {
            if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
                NSMutableString *mutableUserAgent = [userAgent mutableCopy];
                if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                    userAgent = mutableUserAgent;
                }
            }
            headerDictionary[@"User-Agent"] = userAgent; // 用户的头目信息，也就是这个会添加进去了用户的头部信息了， 也就是公共的参数了
        }
        headerDictionary[@"Accept"] = @"image/*,*/*;q=0.8"; // 图片的默认的头部
        _HTTPHeaders = headerDictionary; // 这些用户信息都是放在http的头部
        SD_LOCK_INIT(_HTTPHeadersLock);
        SD_LOCK_INIT(_operationsLock);
        NSURLSessionConfiguration *sessionConfiguration = _config.sessionConfiguration; // 回话的配置
        if (!sessionConfiguration) {
            sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration]; // 没有几位默认的回话配置
        } 
        /**
         *  Create the session for this task
         *  We send nil as delegate queue so that the session creates a serial operation queue for performing all delegate
         *  method calls and completion handler calls.
         */
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                 delegate:self
                                            delegateQueue:nil]; // 创建了当前的session
    }
    return self;
}

- (void)dealloc {
    [self.session invalidateAndCancel];
    self.session = nil;
    
    [self.downloadQueue cancelAllOperations];  // 销毁，取消所有的操作
    [self.config removeObserver:self forKeyPath:NSStringFromSelector(@selector(maxConcurrentDownloads)) context:SDWebImageDownloaderContext];
}

- (void)invalidateSessionAndCancel:(BOOL)cancelPendingOperations {
    if (self == [SDWebImageDownloader sharedDownloader]) {
        return;
    }
    if (cancelPendingOperations) {
        [self.session invalidateAndCancel]; // 有取消的操作
    } else {
        [self.session finishTasksAndInvalidate]; // 已经完成了操作或者是任务失效
    }
}

//  kvc的设置方法
- (void)setValue:(nullable NSString *)value forHTTPHeaderField:(nullable NSString *)field {
    if (!field) {
        return;
    }
    SD_LOCK(_HTTPHeadersLock);
    [self.HTTPHeaders setValue:value forKey:field];
    SD_UNLOCK(_HTTPHeadersLock);
}

//  获取头部的信息
- (nullable NSString *)valueForHTTPHeaderField:(nullable NSString *)field {
    if (!field) {
        return nil;
    }
    SD_LOCK(_HTTPHeadersLock);
    NSString *value = [self.HTTPHeaders objectForKey:field];
    SD_UNLOCK(_HTTPHeadersLock);
    return value;
}

- (nullable SDWebImageDownloadToken *)downloadImageWithURL:(NSURL *)url
                                                 completed:(SDWebImageDownloaderCompletedBlock)completedBlock {
    return [self downloadImageWithURL:url options:0 progress:nil completed:completedBlock];
}

- (nullable SDWebImageDownloadToken *)downloadImageWithURL:(NSURL *)url
                                                   options:(SDWebImageDownloaderOptions)options
                                                  progress:(SDWebImageDownloaderProgressBlock)progressBlock
                                                 completed:(SDWebImageDownloaderCompletedBlock)completedBlock {
    return [self downloadImageWithURL:url options:options context:nil progress:progressBlock completed:completedBlock];
}

//  下载的方法， 有点类似session中的task的内容
- (nullable SDWebImageDownloadToken *)downloadImageWithURL:(nullable NSURL *)url
                                                   options:(SDWebImageDownloaderOptions)options
                                                   context:(nullable SDWebImageContext *)context
                                                  progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                                                 completed:(nullable SDWebImageDownloaderCompletedBlock)completedBlock {
    //  因为这个url作为一个key在回调的字典里面， 所以不可以传入nil
    //  nil直接就创建了一个返回的错误
    if (url == nil) {
        if (completedBlock) {
            NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:SDWebImageErrorInvalidURL userInfo:@{NSLocalizedDescriptionKey : @"Image url is nil"}];
            completedBlock(nil, nil, error, YES);
        }
        return nil;
    }
    
    SD_LOCK(_operationsLock); // 操作的锁
    id downloadOperationCancelToken;
    NSOperation<SDWebImageDownloaderOperation> *operation = [self.URLOperations objectForKey:url]; // 通过这个URl获取有没有operation在这个字典里面了

    //  为什么需要这个处理， 这个是异常特殊情况，看看能否模拟出阿里
    //当一个url operation 不存在、或者下载已经完成或者被取消， 但是没有从这个字典里面移除的时候
    //  完成或者取消，都需要重新添加到对垒处理一遍
    if (!operation || operation.isFinished || operation.isCancelled) {
        operation = [self createDownloaderOperationWithUrl:url options:options context:context];// 创建一个操作对象 ， 可能有其他因素的影响， 这个并不会影响到的
       
    //     以前是不存在，并且现在创建失败， 就直接返回失败了
        if (!operation) { // 表示创建失败， 这个时候创建失败，url创建去下载创失败， 这个要看里面是怎么实现的这个人内容
            SD_UNLOCK(_operationsLock);
            if (completedBlock) {
                NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:SDWebImageErrorInvalidDownloadOperation userInfo:@{NSLocalizedDescriptionKey : @"Downloader operation is nil"}];
                completedBlock(nil, nil, error, YES);
            }
            return nil;
        }
        @weakify(self);

        //  成功返回， 需要去一处这个操作
        operation.completionBlock = ^{
            @strongify(self);
            if (!self) {
                return;
            }
            SD_LOCK(self->_operationsLock);
            [self.URLOperations removeObjectForKey:url];
            SD_UNLOCK(self->_operationsLock);
        };
        self.URLOperations[url] = operation; // 然后将这个放到数据里面

        //  添加处理在提交到操作队列之前，阻止竞争条件（也就是避免竞争）【操作完成在设置处理以前】
        downloadOperationCancelToken = [operation addHandlersForProgress:progressBlock completed:completedBlock];
        
        //  添加到队列 ， 只有在所有的配置挖按成
        //  这个操作是异步的， 所以不会造成死锁
        [self.downloadQueue addOperation:operation];
    } else {
        // When we reuse the download operation to attach more callbacks, there may be thread safe issue because the getter of callbacks may in another queue (decoding queue or delegate queue)
        // So we lock the operation here, and in `SDWebImageDownloaderOperation`, we use `@synchonzied (self)`, to ensure the thread safe between these two classes.
        @synchronized (operation) {
            //  这个东阳需要设置处理的block
            downloadOperationCancelToken = [operation addHandlersForProgress:progressBlock completed:completedBlock];
        }
        if (!operation.isExecuting) { // 设置权限
            if (options & SDWebImageDownloaderHighPriority) {
                operation.queuePriority = NSOperationQueuePriorityHigh;
            } else if (options & SDWebImageDownloaderLowPriority) {
                operation.queuePriority = NSOperationQueuePriorityLow;
            } else {
                operation.queuePriority = NSOperationQueuePriorityNormal;
            }
        }
    }
    SD_UNLOCK(_operationsLock);
    
    // 作为一个token， 当前的token， 这个token有什么作用？
    SDWebImageDownloadToken *token = [[SDWebImageDownloadToken alloc] initWithDownloadOperation:operation];
    token.url = url;
    token.request = operation.request;
    token.downloadOperationCancelToken = downloadOperationCancelToken;
    
    return token;
}


//  根据url、选项以及上下文， 创建一个operation的内容 ， 这个会根据有关的皮遏制
- (nullable NSOperation<SDWebImageDownloaderOperation> *)createDownloaderOperationWithUrl:(nonnull NSURL *)url
                                                                                  options:(SDWebImageDownloaderOptions)options
                                                                                  context:(nullable SDWebImageContext *)context {
    NSTimeInterval timeoutInterval = self.config.downloadTimeout;
    if (timeoutInterval == 0.0) { // 没有设置，默认就是15秒为超时时间
        timeoutInterval = 15.0;
    }
    
    // In order to prevent from potential duplicate caching (NSURLCache + SDImageCache) we disable the cache for image requests if told otherwise
    NSURLRequestCachePolicy cachePolicy = options & SDWebImageDownloaderUseNSURLCache ? NSURLRequestUseProtocolCachePolicy : NSURLRequestReloadIgnoringLocalCacheData; 
    // url 的缓存策略， 是接口缓存策略还是忽略本地缓存数据
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:cachePolicy timeoutInterval:timeoutInterval];
    mutableRequest.HTTPShouldHandleCookies = SD_OPTIONS_CONTAINS(options, SDWebImageDownloaderHandleCookies); // cookies的设置
    mutableRequest.HTTPShouldUsePipelining = YES; // 使用管道， http中的管道， 
    SD_LOCK(_HTTPHeadersLock);
    mutableRequest.allHTTPHeaderFields = self.HTTPHeaders; // 设置了header
    SD_UNLOCK(_HTTPHeadersLock);
    
    // Context Option
    SDWebImageMutableContext *mutableContext;
    if (context) {
        mutableContext = [context mutableCopy];
    } else {
        mutableContext = [NSMutableDictionary dictionary];
    }
    
    // Request Modifier 修饰的内容
    id<SDWebImageDownloaderRequestModifier> requestModifier;
    if ([context valueForKey:SDWebImageContextDownloadRequestModifier]) {
        requestModifier = [context valueForKey:SDWebImageContextDownloadRequestModifier];
    } else {
        requestModifier = self.requestModifier;
    }
    
    NSURLRequest *request;
    if (requestModifier) {
        NSURLRequest *modifiedRequest = [requestModifier modifiedRequestWithRequest:[mutableRequest copy]];
        // If modified request is nil, early return
        if (!modifiedRequest) {
            return nil;
        } else {
            request = [modifiedRequest copy];
        }
    } else {
        request = [mutableRequest copy];
    }
    
    // Response Modifier
    id<SDWebImageDownloaderResponseModifier> responseModifier;
    if ([context valueForKey:SDWebImageContextDownloadResponseModifier]) {
        responseModifier = [context valueForKey:SDWebImageContextDownloadResponseModifier];
    } else {
        responseModifier = self.responseModifier;
    }
    if (responseModifier) {
        mutableContext[SDWebImageContextDownloadResponseModifier] = responseModifier;
    }


    // Decryptor
    id<SDWebImageDownloaderDecryptor> decryptor;
    if ([context valueForKey:SDWebImageContextDownloadDecryptor]) {
        decryptor = [context valueForKey:SDWebImageContextDownloadDecryptor];
    } else {
        decryptor = self.decryptor;
    }
    if (decryptor) {
        mutableContext[SDWebImageContextDownloadDecryptor] = decryptor;
    }
    
    context = [mutableContext copy];
    
    // Operation Class
    Class operationClass = self.config.operationClass;
    if (operationClass && [operationClass isSubclassOfClass:[NSOperation class]] && [operationClass conformsToProtocol:@protocol(SDWebImageDownloaderOperation)]) {
        // Custom operation class
    } else {
        operationClass = [SDWebImageDownloaderOperation class];
    }
    NSOperation<SDWebImageDownloaderOperation> *operation = [[operationClass alloc] initWithRequest:request inSession:self.session options:options context:context];
    
    //  设置证书的内容
    if ([operation respondsToSelector:@selector(setCredential:)]) {
        if (self.config.urlCredential) {
            operation.credential = self.config.urlCredential;
        } else if (self.config.username && self.config.password) {
            operation.credential = [NSURLCredential credentialWithUser:self.config.username password:self.config.password persistence:NSURLCredentialPersistenceForSession];
        }
    }
        
        //  设置最小的进度间隔
    if ([operation respondsToSelector:@selector(setMinimumProgressInterval:)]) {
        operation.minimumProgressInterval = MIN(MAX(self.config.minimumProgressInterval, 0), 1);
    }
    
    //  设置优先级
    if (options & SDWebImageDownloaderHighPriority) {
        operation.queuePriority = NSOperationQueuePriorityHigh;
    } else if (options & SDWebImageDownloaderLowPriority) {
        operation.queuePriority = NSOperationQueuePriorityLow;
    }
    
    //  先进先出， 这个好像就没有了依赖的关系
    if (self.config.executionOrder == SDWebImageDownloaderLIFOExecutionOrder) {//  这个后进先出
        // Emulate LIFO execution order by systematically, each previous adding operation can dependency the new operation
        // This can gurantee the new operation to be execulated firstly, even if when some operations finished, meanwhile you appending new operations
        // Just make last added operation dependents new operation can not solve this problem. See test case #test15DownloaderLIFOExecutionOrder
        for (NSOperation *pendingOperation in self.downloadQueue.operations) {
            [pendingOperation addDependency:operation]; // 依赖的关系
        }
    }
    
    return operation;
}

- (void)cancelAllDownloads {
    [self.downloadQueue cancelAllOperations];
}

#pragma mark - Properties

- (BOOL)isSuspended {
    return self.downloadQueue.isSuspended;
}

- (void)setSuspended:(BOOL)suspended {
    self.downloadQueue.suspended = suspended;
}

- (NSUInteger)currentDownloadCount {
    return self.downloadQueue.operationCount;
}

- (NSURLSessionConfiguration *)sessionConfiguration {
    return self.session.configuration;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == SDWebImageDownloaderContext) {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(maxConcurrentDownloads))]) {
            self.downloadQueue.maxConcurrentOperationCount = self.config.maxConcurrentDownloads;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark Helper methods

//  根据task或者operation
- (NSOperation<SDWebImageDownloaderOperation> *)operationWithTask:(NSURLSessionTask *)task {
    NSOperation<SDWebImageDownloaderOperation> *returnOperation = nil;
    for (NSOperation<SDWebImageDownloaderOperation> *operation in self.downloadQueue.operations) {
        if ([operation respondsToSelector:@selector(dataTask)]) {
            // So we lock the operation here, and in `SDWebImageDownloaderOperation`, we use `@synchonzied (self)`, to ensure the thread safe between these two classes.
            NSURLSessionTask *operationTask;
            @synchronized (operation) {
                operationTask = operation.dataTask;
            }
            if (operationTask.taskIdentifier == task.taskIdentifier) {
                returnOperation = operation;
                break;
            }
        }
    }
    return returnOperation;
}

#pragma mark NSURLSessionDataDelegate

//  sesdsion的数据的回调处理
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {

    // Identify the operation that runs this task and pass it the delegate method
    NSOperation<SDWebImageDownloaderOperation> *dataOperation = [self operationWithTask:dataTask];
    if ([dataOperation respondsToSelector:@selector(URLSession:dataTask:didReceiveResponse:completionHandler:)]) {
        [dataOperation URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
    } else {
        if (completionHandler) {
            completionHandler(NSURLSessionResponseAllow);
        }
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {

    // Identify the operation that runs this task and pass it the delegate method
    NSOperation<SDWebImageDownloaderOperation> *dataOperation = [self operationWithTask:dataTask];
    if ([dataOperation respondsToSelector:@selector(URLSession:dataTask:didReceiveData:)]) {
        [dataOperation URLSession:session dataTask:dataTask didReceiveData:data];
    }
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler {

    // Identify the operation that runs this task and pass it the delegate method
    NSOperation<SDWebImageDownloaderOperation> *dataOperation = [self operationWithTask:dataTask];
    if ([dataOperation respondsToSelector:@selector(URLSession:dataTask:willCacheResponse:completionHandler:)]) {
        [dataOperation URLSession:session dataTask:dataTask willCacheResponse:proposedResponse completionHandler:completionHandler];
    } else {
        if (completionHandler) {
            completionHandler(proposedResponse);
        }
    }
}
// 上面只管是处理数据就可以了， 
//  下面的额是人的问题， 针对任务处理， 
//  从两个任务去区分的力度

#pragma mark NSURLSessionTaskDelegate
//  任务的回调粒度

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    // Identify the operation that runs this task and pass it the delegate method
    NSOperation<SDWebImageDownloaderOperation> *dataOperation = [self operationWithTask:task];
    if ([dataOperation respondsToSelector:@selector(URLSession:task:didCompleteWithError:)]) {
        [dataOperation URLSession:session task:task didCompleteWithError:error];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    
    // Identify the operation that runs this task and pass it the delegate method
    NSOperation<SDWebImageDownloaderOperation> *dataOperation = [self operationWithTask:task];
    if ([dataOperation respondsToSelector:@selector(URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:)]) {
        [dataOperation URLSession:session task:task willPerformHTTPRedirection:response newRequest:request completionHandler:completionHandler];
    } else {
        if (completionHandler) {
            completionHandler(request);
        }
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {

    // Identify the operation that runs this task and pass it the delegate method
    NSOperation<SDWebImageDownloaderOperation> *dataOperation = [self operationWithTask:task];
    if ([dataOperation respondsToSelector:@selector(URLSession:task:didReceiveChallenge:completionHandler:)]) {
        [dataOperation URLSession:session task:task didReceiveChallenge:challenge completionHandler:completionHandler];
    } else {
        if (completionHandler) {
            completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
        }
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0)) {
    
    // Identify the operation that runs this task and pass it the delegate method
    NSOperation<SDWebImageDownloaderOperation> *dataOperation = [self operationWithTask:task];
    if ([dataOperation respondsToSelector:@selector(URLSession:task:didFinishCollectingMetrics:)]) {
        [dataOperation URLSession:session task:task didFinishCollectingMetrics:metrics];
    }
}

@end


