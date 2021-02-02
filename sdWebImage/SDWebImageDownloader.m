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


____________________________________________________________________________________________________
.m 文件
____________________________________________________________________________________________________
