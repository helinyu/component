
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

