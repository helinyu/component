#import "SDImageLoader.h"

//  下载器的管理类， 这里会有多个下载器
//   图片下载的管理器类， 这个管理类本身就继承这个sdImageLoader ，我中有我
// 以为这个过程，如果我中有我， 很可能会有死循环的

// 目前基本的使用， 是没有执行这个的； 看看以后我们和YYLoader的内容结合的话， 会是怎么处理的；

@interface SDImageLoadersManager : NSObject <SDImageLoader>

// 单例
@property (nonatomic, class, readonly, nonnull) SDImageLoadersManager *sharedManager;

// 这个是一个权限的队列， 
//   为什么有这个么多个loader？ 应该是这里有个链表， 我猜测的 ， 后来的加载器将会有最好的权限， 为什么？=
@property (nonatomic, copy, nullable) NSArray<id<SDImageLoader>>* loaders;

//  它这个设定的， 后来添加的具有最后的权限
- (void)addLoader:(nonnull id<SDImageLoader>)loader;

//  删除一个loader 
- (void)removeLoader:(nonnull id<SDImageLoader>)loader;

@end


//  有点不太习惯于自己里面很有可能是宝行自己的， 如果是宝行自己的，会怎么去处理？

// .m 文件中， 存储loader的对象
@interface SDImageLoadersManager ()

@property (nonatomic, strong, nonnull) NSMutableArray<id<SDImageLoader>> *imageLoaders;

@end

@implementation SDImageLoadersManager {
    SD_LOCK_DECLARE(_loadersLock);
}

+ (SDImageLoadersManager *)sharedManager {
    static dispatch_once_t onceToken;
    static SDImageLoadersManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[SDImageLoadersManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // initialize with default image loaders
        _imageLoaders = [NSMutableArray arrayWithObject:[SDWebImageDownloader sharedDownloader]];
        SD_LOCK_INIT(_loadersLock);
    }
    return self;
}

- (NSArray<id<SDImageLoader>> *)loaders { // 返回不可变的数组
    SD_LOCK(_loadersLock);
    NSArray<id<SDImageLoader>>* loaders = [_imageLoaders copy];
    SD_UNLOCK(_loadersLock);
    return loaders;
}

- (void)setLoaders:(NSArray<id<SDImageLoader>> *)loaders { // 添加新的数组
    SD_LOCK(_loadersLock);
    [_imageLoaders removeAllObjects];
    if (loaders.count) {
        [_imageLoaders addObjectsFromArray:loaders];
    }
    SD_UNLOCK(_loadersLock);
}

#pragma mark - Loader Property

- (void)addLoader:(id<SDImageLoader>)loader { // 添加新的一个loader
    if (![loader conformsToProtocol:@protocol(SDImageLoader)]) {
        return;
    }
    SD_LOCK(_loadersLock);
    [_imageLoaders addObject:loader];
    SD_UNLOCK(_loadersLock);
}

- (void)removeLoader:(id<SDImageLoader>)loader { // 删除一个loader
    if (![loader conformsToProtocol:@protocol(SDImageLoader)]) {
        return;
    }
    SD_LOCK(_loadersLock);
    [_imageLoaders removeObject:loader];
    SD_UNLOCK(_loadersLock);
}

#pragma mark - SDImageLoader

- (BOOL)canRequestImageForURL:(nullable NSURL *)url { // 这个loader有没有可能是我自己的
    NSArray<id<SDImageLoader>> *loaders = self.loaders;
    // 为什么这个逻辑是可以这样去处理的？ 应该是模块话了之后的处理 
    for (id<SDImageLoader> loader in loaders.reverseObjectEnumerator) {
        if ([loader canRequestImageForURL:url]) { // 这个会之心到哪里？ 感觉有点诡异， 如果所， 这样的话，只能够是其他的loader的对象了， 那威慑呢么这个类要实现接口SDImageLoader
            return YES;
        }
    }
    return NO;
}

// 真实的请求，
- (id<SDWebImageOperation>)requestImageWithURL:(NSURL *)url options:(SDWebImageOptions)options context:(SDWebImageContext *)context progress:(SDImageLoaderProgressBlock)progressBlock completed:(SDImageLoaderCompletedBlock)completedBlock {
    if (!url) {
        return nil;
    }
    NSArray<id<SDImageLoader>> *loaders = self.loaders;
    for (id<SDImageLoader> loader in loaders.reverseObjectEnumerator) {
        if ([loader canRequestImageForURL:url]) {
            return [loader requestImageWithURL:url options:options context:context progress:progressBlock completed:completedBlock];
        }
    }
    return nil;
}

// 是否blockfail的情况
- (BOOL)shouldBlockFailedURLWithURL:(NSURL *)url error:(NSError *)error {
    NSArray<id<SDImageLoader>> *loaders = self.loaders;
    for (id<SDImageLoader> loader in loaders.reverseObjectEnumerator) {
        if ([loader canRequestImageForURL:url]) {
            return [loader shouldBlockFailedURLWithURL:url error:error];
        }
    }
    return NO;
}

@end


