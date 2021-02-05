// AFURLSessionManager.h
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

#import "AFURLResponseSerialization.h"
#import "AFURLRequestSerialization.h"
#import "AFSecurityPolicy.h"
#import "AFCompatibilityMacros.h"
#if !TARGET_OS_WATCH
#import "AFNetworkReachabilityManager.h"
#endif

/**
 AFURLSessionManager 创建和管理一个NSURLSession对象， 基于NSURLSessionConfiguration 对象， 对应`<NSURLSessionTaskDelegate>`, `<NSURLSessionDataDelegate>`, `<NSURLSessionDownloadDelegate>`, and `<NSURLSessionDelegate>` 这几个代理
 AFHTTPSessionManager 是AFURLSessionManager 子类， 做http请求
 
 ## NSURLSession & NSURLSessionTask Delegate Methods

 `AFURLSessionManager` implements the following delegate methods:

 ### `NSURLSessionDelegate`

 - `URLSession:didBecomeInvalidWithError:`
 - `URLSession:didReceiveChallenge:completionHandler:`
 - `URLSessionDidFinishEventsForBackgroundURLSession:`

 ### `NSURLSessionTaskDelegate`

 - `URLSession:willPerformHTTPRedirection:newRequest:completionHandler:`
 - `URLSession:task:didReceiveChallenge:completionHandler:`
 - `URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:`
 - `URLSession:task:needNewBodyStream:`
 - `URLSession:task:didCompleteWithError:`

 ### `NSURLSessionDataDelegate`

 - `URLSession:dataTask:didReceiveResponse:completionHandler:`
 - `URLSession:dataTask:didBecomeDownloadTask:`
 - `URLSession:dataTask:didReceiveData:`
 - `URLSession:dataTask:willCacheResponse:completionHandler:`

 ### `NSURLSessionDownloadDelegate`

 - `URLSession:downloadTask:didFinishDownloadingToURL:`
 - `URLSession:downloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:`
 - `URLSession:downloadTask:didResumeAtOffset:expectedTotalBytes:`


 ## Network Reachability Monitoring （网络可达的控制）
网络可达的状态改变控制通过reachabilityManager 属性，
 应用鞥能够选择一个控制网络可达的状态 为了阻止或者悬挂一些超出范围的请求
 ：AFNetworkReachabilityManager 有细节


 —— 编码注意事项：
  编码管理器没有包括block属性， 确定设置代理回调当使用-initWithCoder: 或者NSKeyedUnarchiver

—— 拷贝注意事项：
 -copy` 和 `-copyWithZone: 返回一个新的管理器返回有一个新的NSURLSession ， 通过一个原始的配置创建一个NSURLSession
 拷贝操作没有包括代理回调的blocks， 因为他们经常捕获到self的应用，  这样可能会有副作用支出原始的回话管理器，当拷贝的时候；
注意： 对于后台session的管理器， 必须拥有在它们被使用的的时候，这个能够被完成通过创建一个应用端或者单例的实例

 */

NS_ASSUME_NONNULL_BEGIN

@interface AFURLSessionManager : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate, NSSecureCoding, NSCopying>

// 如何判断哪个是哪个的， 应该是用一个字典来存储数组的内容
// 管理的会话
@property (readonly, nonatomic, strong) NSURLSession *session;

// 操作的队列
@property (readonly, nonatomic, strong) NSOperationQueue *operationQueue;

// 详情的系列化，dataTaskWithRequest:success:failure:` 请求返回的来的数据，可以使用 get/post 等请求，
// 便利店饿方法是自动有效和通过response系列化。 默认， 这个属性被设置为一个AFJSONResponseSerializer 对象， 也就是将返回的饿对象系列化
@property (nonatomic, strong) id <AFURLResponseSerialization> responseSerializer;


// 安全策略， 用于处理服务器安全连接的的安全策略，AFURLSessionManager 使用默认的测录， 除非有特殊指定
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;

#if !TARGET_OS_WATCH
// 可达管理器，AFURLSessionManager 使用了默认的方式
@property (readwrite, nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;
#endif

// 获取session的task(任务)， 数据： 上传、下载通过当前管理的session
@property (readonly, nonatomic, strong) NSArray <NSURLSessionTask *> *tasks;

// 当前管理session的数据任务
@property (readonly, nonatomic, strong) NSArray <NSURLSessionDataTask *> *dataTasks;

// 当前管理session的上传的任务
@property (readonly, nonatomic, strong) NSArray <NSURLSessionUploadTask *> *uploadTasks;

// 当前下载的任务
@property (readonly, nonatomic, strong) NSArray <NSURLSessionDownloadTask *> *downloadTasks;

//管理回调的队列，（completionBlock），如果是NULL，表示是默认的， 主线程被使用
@property (nonatomic, strong, nullable) dispatch_queue_t completionQueue;

// 回调的dispatch group (completionBlock)，如果是NULL，表示是默认的， 主线程被使用
@property (nonatomic, strong, nullable) dispatch_group_t completionGroup;

// ___ 下面是初始化的方法————————

// 通过指定的config创建病返回一个session的管理器，
//config 是指定的配置
- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration NS_DESIGNATED_INITIALIZER;

// 是被管理的session无效； 一般， 取消拼接任务和充值给出的session
// cancelPendingTasks 是否取消添加的任务
// 是哦福充值session管理器
- (void)invalidateSessionCancelingTasks:(BOOL)cancelPendingTasks resetSession:(BOOL)resetSession;

// ——————————下面是运行数据的任务 ————————————————————————————

// 创建一个通过request 指定的任务 NSURLSessionDataTask （会话数据任务）
// http的请求
// uploadProgressBlock 上传的进度回调
// downloadProgressBlock 下载的进度回调
// completionHandler 完成的处理
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                               uploadProgress:(nullable void (^)(NSProgress *uploadProgress))uploadProgressBlock
                             downloadProgress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                            completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler;

// —————————— 运行上传的任务 ————————————————————————————

// request  还是http的请求
// fileURL 本地文件的路径的URL
// uploadProgressBlock 上传的进度
// completionHandler 完成的进度
// attemptsToRecreateUploadTasksForBackgroundSessions 查看这个方法， 这个y9inggai是session的方法
- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request
                                         fromFile:(NSURL *)fileURL
                                         progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgressBlock
                                completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject, NSError  * _Nullable error))completionHandler;

// 创建一个NSURLSessionUploadTask 上传的任务， 通过一个http的body
// request： http的请求
// bodyData body的数据的方式， 一个NSdata的数据， 包括了http体被上传
// uploadProgressBlock 上传的进度
// 完成的回调
- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request
                                         fromData:(nullable NSData *)bodyData
                                         progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgressBlock
                                completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject, NSError * _Nullable error))completionHandler;

// 创建一个（NSURLSessionUploadTask）上传任务， 使用流（streaming）请求
// request http 的请求
// uploadProgressBlock 上传的进度
// completionHandler 完成的进度
- (NSURLSessionUploadTask *)uploadTaskWithStreamedRequest:(NSURLRequest *)request
                                                 progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgressBlock
                                        completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject, NSError * _Nullable error))completionHandler;

// ———————————————————— 运行下载的任务 ————————————————————————————————————————

// 通过指定一个NSURLRequest 来创建一个 NSURLSessionDownloadTask
// request: http 的请求
// downloadProgressBlock 下载的进度回调
// destination：一个block对象目的是确定下载文件的目标。 这个目标带有两个参数：targetPath 和 response ， 返回下载结果中要求的url，  暂时的文件将会自动删除在下载被移动到返回的URL中的是哦户； ——>  就是将下载的数据移动到目标的URL的位置中
// completionHandler 下载完成的回调
// 注意：如果使用后台的NSURLSessionConfiguration 配置在ios中， 这些快讲被丢失，当app被终止的是偶
// 后台的session 应该选择使用setDownloadTaskDidFinishDownloadingBlock 方法指定一个URL保存下载的文件，而不是这个方法
- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request
                                             progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                          destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                    completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;

// 创建一个NSURLSessionDownloadTask 使用指定的resume data (继续下载)
// resumeData 数据用于resume 下载 —— 【resume 不知道是什么概念】
// downloadProgressBlock 、destination 、 completionHandler
- (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData
                                                progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                             destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                       completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;


// ———————————— 获取一个有进度的任务 ——————————————————————————————

//上传任务的进度 ， task就是任务， 必须不为nil
// 返回已给上传的进度，
- (nullable NSProgress *)uploadProgressForTask:(NSURLSessionTask *)task;

// 下载的进度
- (nullable NSProgress *)downloadProgressForTask:(NSURLSessionTask *)task;


// ———————————————— 设置session的代理回调 ——————————————————

// didBecomeInvalidWithError 请求回话变成了无效的block回调
- (void)setSessionDidBecomeInvalidBlock:(nullable void (^)(NSURLSession *session, NSError *error))block;


// 设置验证的回调
- (void)setSessionDidReceiveAuthenticationChallengeBlock:(nullable NSURLSessionAuthChallengeDisposition (^)(NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential * _Nullable __autoreleasing * _Nullable credential))block;

// —————————— 设置任务代理回调 ————————————

//设置block 去执行， 当一个任务请求一个新的请求体 流 到一个远程的服务器， 例如： 通过 NSURLSessionTaskDelegate 的RLSession:task:needNewBodyStream:` 方法 回调
// 这个block 会执行， 当一个任务需要一个新的请求体流
- (void)setTaskNeedNewBodyStreamBlock:(nullable NSInputStream * (^)(NSURLSession *session, NSURLSessionTask *task))block;

//设置block 去执行， 当一个http请求尝试去执行一个重定向大奥一个不同的URL， 这个block返回请求的重定向的请求， 有4个参数：session， task、 重定向的相应、 对应冲形象相应的请求
- (void)setTaskWillPerformHTTPRedirectionBlock:(nullable NSURLRequest * _Nullable (^)(NSURLSession *session, NSURLSessionTask *task, NSURLResponse *response, NSURLRequest *request))block;

/**
 Sets a block to be executed when a session task has received a request specific authentication challenge, as handled by the `NSURLSessionTaskDelegate` method `URLSession:task:didReceiveChallenge:completionHandler:`.
 
 @param authenticationChallengeHandler A block object to be executed when a session task has received a request specific authentication challenge.
 
 When implementing an authentication challenge handler, you should check the authentication method first (`challenge.protectionSpace.authenticationMethod `) to decide if you want to handle the authentication challenge yourself or if you want AFNetworking to handle it. If you want AFNetworking to handle the authentication challenge, just return `@(NSURLSessionAuthChallengePerformDefaultHandling)`. For example, you certainly want AFNetworking to handle certificate validation (i.e. authentication method == `NSURLAuthenticationMethodServerTrust`) as defined by the security policy. If you want to handle the challenge yourself, you have four options:
 
 1. Return `nil` from the authentication challenge handler. You **MUST** call the completion handler with a disposition and credentials yourself. Use this if you need to present a user interface to let the user enter their credentials.
 2. Return an `NSError` object from the authentication challenge handler. You **MUST NOT** call the completion handler when returning an `NSError `. The returned error will be reported in the completion handler of the task. Use this if you need to abort an authentication challenge with a specific error.
 3. Return an `NSURLCredential` object from the authentication challenge handler. You **MUST NOT** call the completion handler when returning an `NSURLCredential`. The returned credentials will be used to fulfil the challenge. Use this when you can get credentials without presenting a user interface.
 4. Return an `NSNumber` object wrapping an `NSURLSessionAuthChallengeDisposition`. Supported values are `@(NSURLSessionAuthChallengePerformDefaultHandling)`, `@(NSURLSessionAuthChallengeCancelAuthenticationChallenge)` and `@(NSURLSessionAuthChallengeRejectProtectionSpace)`. You **MUST NOT** call the completion handler when returning an `NSNumber`.
 
 If you return anything else from the authentication challenge handler, an exception will be thrown.
 
 For more information about how URL sessions handle the different types of authentication challenges, see [NSURLSession](https://developer.apple.com/reference/foundation/nsurlsession?language=objc) and [URL Session Programming Guide](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/URLLoadingSystem/URLLoadingSystem.html).
 
 @see -securityPolicy
 */

// 设置了认证的回调 ， 可以去看securityPolicy 这个东西
- (void)setAuthenticationChallengeHandler:(id (^)(NSURLSession *session, NSURLSessionTask *task, NSURLAuthenticationChallenge *challenge, void (^completionHandler)(NSURLSessionAuthChallengeDisposition , NSURLCredential * _Nullable)))authenticationChallengeHandler;

// 上传进度的回调的block， 其中的 NSURLSessionTaskDelegate` method `URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:`.
// 有关的参数， 就是对应的信息了
- (void)setTaskDidSendBodyDataBlock:(nullable void (^)(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend))block;

// 设置一个block指定在最新的信息关联到指定的任务， 通过NSURLSessionTaskDelegate 的URLSession:task:didCompleteWithError: 方法
// block ， 当一个session task 任务完成的时候回呗执行， block没有返回值， 有三个参数， session，task， 或者error在执行任务中产生
- (void)setTaskDidCompleteBlock:(nullable void (^)(NSURLSession *session, NSURLSessionTask *task, NSError * _Nullable error))block;

// 检测网络的回调
#if AF_CAN_INCLUDE_SESSION_TASK_METRICS
- (void)setTaskDidFinishCollectingMetricsBlock:(nullable void (^)(NSURLSession *session, NSURLSessionTask *task, NSURLSessionTaskMetrics * _Nullable metrics))block AF_API_AVAILABLE(ios(10), macosx(10.12), watchos(3), tvos(10));
#endif

// ———————————— data task delegate callback 数据任务的代理回调 ——————————————

// 接收到响应的回调
- (void)setDataTaskDidReceiveResponseBlock:(nullable NSURLSessionResponseDisposition (^)(NSURLSession *session, NSURLSessionDataTask *dataTask, NSURLResponse *response))block;

// 下载的数据的回调
- (void)setDataTaskDidBecomeDownloadTaskBlock:(nullable void (^)(NSURLSession *session, NSURLSessionDataTask *dataTask, NSURLSessionDownloadTask *downloadTask))block;

// 接收到数据 ， NSData格式的数据
- (void)setDataTaskDidReceiveDataBlock:(nullable void (^)(NSURLSession *session, NSURLSessionDataTask *dataTask, NSData *data))block;

// 数据任务将会缓存的回调
- (void)setDataTaskWillCacheResponseBlock:(nullable NSCachedURLResponse * (^)(NSURLSession *session, NSURLSessionDataTask *dataTask, NSCachedURLResponse *proposedResponse))block;

// 后台回话完成的回调
- (void)setDidFinishEventsForBackgroundURLSessionBlock:(nullable void (^)(NSURLSession *session))block AF_API_UNAVAILABLE(macos);

// ——————————————————————— 设置下子任务代理的回调 ——————————————————

// 下载完成的回调
- (void)setDownloadTaskDidFinishDownloadingBlock:(nullable NSURL * _Nullable  (^)(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, NSURL *location))block;

// 下数据的回调， `NSURLSessionDownloadDelegate` method `URLSession:downloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:`.
// 应该是将数据写到本地的进度的回调
- (void)setDownloadTaskDidWriteDataBlock:(nullable void (^)(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite))block;

// 下载的重新继续下载的回调
- (void)setDownloadTaskDidResumeBlock:(nullable void (^)(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t fileOffset, int64_t expectedTotalBytes))block;

@end

// ———————————— 通知 ————————————————————————————

// 当一个任务继续的时候的通知
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidResumeNotification;

// 当一个任务已经完成的通知， 包括userInfo 带有关于任务的信息
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidCompleteNotification;

// 当一个任务悬挂的时候
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidSuspendNotification;

// post 一个无效的session
FOUNDATION_EXPORT NSString * const AFURLSessionDidInvalidateNotification;

// 一个下载的任务完成了将一个下载的临时文件移除到目标地址成功
FOUNDATION_EXPORT NSString * const AFURLSessionDownloadTaskDidMoveFileSuccessfullyNotification;

// 当一个下载任务出现错误， 将一个下载的临时文件指定到一个指定的目的地
FOUNDATION_EXPORT NSString * const AFURLSessionDownloadTaskDidFailToMoveFileNotification;

// 原生的数据任务， 在的AFNetworkingTaskDidCompleteNotification 的字典里面
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidCompleteResponseDataKey;


//响应数据的任务，在AFNetworkingTaskDidCompleteNotification 通知的userInfo 的字典里面；
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidCompleteSerializedResponseKey;

//AFNetworkingTaskDidCompleteNotification 通知的userINfo 中包含响应的系列化
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidCompleteResponseSerializerKey;

// asset的路径的key， 包括userInfo 中的AFNetworkingTaskDidCompleteNotification， 如果一个响应数据已经被直接存储到磁盘中
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidCompleteAssetPathKey;

//一个错误关联的任务，AFNetworkingTaskDidCompleteNotification 通知中的userInfo
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidCompleteErrorKey;

// 下载任务的回话检测， 通知的userInfo 中的有这个key
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidCompleteSessionTaskMetrics;

NS_ASSUME_NONNULL_END
