NSURL : 这个内容是和url有关的操作 
NSURLComponents 里面包括url上面的不同的段

NSURLAuthenticationChallenge  应该是和验证有关的内容
NSURLCredential  这个关于url的证书信任的内容
NSURLCredentialStorage 证书的缓存

NSURLError url的错误

NSCachedURLResponse url的响应缓存
NSURLCache url的缓存

NSURLConnection url的连接， 这个基本上不用了

NSURLProtectionSpace 保护空间

NSURLProtocolClient 接口
NSURLProtocol  抽象类

NSURLRequest 请求的准备对象
NSURLResponse url的响应
NSURLSession url的回话，基本上是用来替换NSURLConnection

NSURLSessionConfiguration 回话的配置

NSURLSessionTaskMetrics 统计https请求过程哪个过程是缓慢的



// 请求特定的身份验证质询
//  回话授权挑战的枚举
typedef NS_ENUM(NSInteger, NSURLSessionAuthChallengeDisposition) {
    NSURLSessionAuthChallengeUseCredential = 0,     
    /*  使用指定的认证，可能是nil */

    NSURLSessionAuthChallengePerformDefaultHandling = 1,    
    /*  challenge 的默认处理方式，如果dialing没有实现的话； 认证参数会被忽略 */

    NSURLSessionAuthChallengeCancelAuthenticationChallenge = 2,   
    // 整个请求将会被取消， 认证参数被忽略

    NSURLSessionAuthChallengeRejectProtectionSpace = 3,          
    // 挑战被拒绝和下一个验证保护欧诺个件将会尝试， 认证参数被忽略
} API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0));


//  决定，接下来的变量来处理什么
typedef NS_ENUM(NSInteger, NSURLSessionResponseDisposition) {
    NSURLSessionResponseCancel = 0, // 响应允许
    NSURLSessionResponseAllow = 1, // 加载继续    
    NSURLSessionResponseBecomeDownload = 2,  // 变成下载           
    NSURLSessionResponseBecomeStream API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0)) = 3, 
    // 转换这个任务变成流任务
} API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0));



@protocol NSURLSessionTaskDelegate <NSURLSessionDelegate>

//  代理回调
//  如果需要请求一个新的不打开的流体。 当调用一个流体的验证失败的时候，这个可可能需要处理的。
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
                              needNewBodyStream:(void (^)(NSInputStream * _Nullable bodyStream))completionHandler NS_SWIFT_ASYNC_NAME(urlSession(_:needNewBodyStreamForTask:));

//  定期发送通知到代理上传进度
// 这个信息对于task的属性是有效的。
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
                                didSendBodyData:(int64_t)bytesSent
                                 totalBytesSent:(int64_t)totalBytesSent
                       totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend;

// 

@end