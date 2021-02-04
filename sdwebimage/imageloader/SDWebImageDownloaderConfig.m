// 配置的内容， 主要是下载的时候可以配置的内容
/// Operation execution order
typedef NS_ENUM(NSInteger, SDWebImageDownloaderExecutionOrder) {
    //   默认是先进先出的执行顺序
    SDWebImageDownloaderFIFOExecutionOrder,
    
//  后进先出
    SDWebImageDownloaderLIFOExecutionOrder
};

//  下载的配置内容
@interface SDWebImageDownloaderConfig : NSObject <NSCopying>

//  默认的配置内容
@property (nonatomic, class, readonly, nonnull) SDWebImageDownloaderConfig *defaultDownloaderConfig; // 这里默认的配置， 什么东西都没有弄
//  默认最大数量是6
@property (nonatomic, assign) NSInteger maxConcurrentDownloads;

//  默认为15s
@property (nonatomic, assign) NSTimeInterval downloadTimeout;

//  这个应该是做一个数据传输上面的进度的问题；
//  关于在网络下载的过程中的进度， 以为这下一个进度会带哦和当前进度回调的不同，必须大于或者等于这个最小的间隔， 也就是如果我们设置为0.1， 只有下载的数据距离上一次大于等于0.1之后，才会进行回调
//  范围在0.0~1.0之间
// 注意： 如果你使用了进度解码的特新， 这个将会同样影响到图片的刷新速率
//  默认是0， 以为这个有新的数据就会立马回调
@property (nonatomic, assign) double minimumProgressInterval;

//   默认是nil， 自定义的皮遏制， 如果没有设置， 使用默认的， 不支持动态改变
@property (nonatomic, strong, nullable) NSURLSessionConfiguration *sessionConfiguration;

//  操作类， 默认是nil， 
@property (nonatomic, assign, nullable) Class operationClass;

//   改变操作的执行之心， 默认是先进先出
@property (nonatomic, assign) SDWebImageDownloaderExecutionOrder executionOrder;

//   url的验证， 默认是nil
@property (nonatomic, copy, nullable) NSURLCredential *urlCredential;

//   用户的名字， 默认是nil
@property (nonatomic, copy, nullable) NSString *username;

//  http验证的时候， 需要的密码， 默认是nil
@property (nonatomic, copy, nullable) NSString *password;

@end

static SDWebImageDownloaderConfig * _defaultDownloaderConfig;

@implementation SDWebImageDownloaderConfig

+ (SDWebImageDownloaderConfig *)defaultDownloaderConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultDownloaderConfig = [SDWebImageDownloaderConfig new];
    });
    return _defaultDownloaderConfig;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _maxConcurrentDownloads = 6;
        _downloadTimeout = 15.0;
        _executionOrder = SDWebImageDownloaderFIFOExecutionOrder;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    SDWebImageDownloaderConfig *config = [[[self class] allocWithZone:zone] init];
    config.maxConcurrentDownloads = self.maxConcurrentDownloads;
    config.downloadTimeout = self.downloadTimeout;
    config.minimumProgressInterval = self.minimumProgressInterval;
    config.sessionConfiguration = [self.sessionConfiguration copyWithZone:zone];
    config.operationClass = self.operationClass;
    config.executionOrder = self.executionOrder;
    config.urlCredential = self.urlCredential;
    config.username = self.username;
    config.password = self.password;
    
    return config;
}

@end
