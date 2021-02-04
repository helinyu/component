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
 `AFURLSessionManager` creates and manages an `NSURLSession` object based on a specified `NSURLSessionConfiguration` object, which conforms to `<NSURLSessionTaskDelegate>`, `<NSURLSessionDataDelegate>`, `<NSURLSessionDownloadDelegate>`, and `<NSURLSessionDelegate>`.

 ## Subclassing Notes

 This is the base class for `AFHTTPSessionManager`, which adds functionality specific to making HTTP requests. If you are looking to extend `AFURLSessionManager` specifically for HTTP, consider subclassing `AFHTTPSessionManager` instead.

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

 If any of these methods are overridden in a subclass, they _must_ call the `super` implementation first.

 ## Network Reachability Monitoring

 Network reachability status and change monitoring is available through the `reachabilityManager` property. Applications may choose to monitor network reachability conditions in order to prevent or suspend any outbound requests. See `AFNetworkReachabilityManager` for more details.

 ## NSCoding Caveats

 - Encoded managers do not include any block properties. Be sure to set delegate callback blocks when using `-initWithCoder:` or `NSKeyedUnarchiver`.

 ## NSCopying Caveats

 - `-copy` and `-copyWithZone:` return a new manager with a new `NSURLSession` created from the configuration of the original.
 - Operation copies do not include any delegate callback blocks, as they often strongly captures a reference to `self`, which would otherwise have the unintuitive side-effect of pointing to the _original_ session manager when copied.

 @warning Managers for background sessions must be owned for the duration of their use. This can be accomplished by creating an application-wide or shared singleton instance.
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

///-----------------------------------------
/// @name Setting Session Delegate Callbacks
///-----------------------------------------

/**
 Sets a block to be executed when the managed session becomes invalid, as handled by the `NSURLSessionDelegate` method `URLSession:didBecomeInvalidWithError:`.

 @param block A block object to be executed when the managed session becomes invalid. The block has no return value, and takes two arguments: the session, and the error related to the cause of invalidation.
 */
- (void)setSessionDidBecomeInvalidBlock:(nullable void (^)(NSURLSession *session, NSError *error))block;

/**
 Sets a block to be executed when a connection level authentication challenge has occurred, as handled by the `NSURLSessionDelegate` method `URLSession:didReceiveChallenge:completionHandler:`.

 @param block A block object to be executed when a connection level authentication challenge has occurred. The block returns the disposition of the authentication challenge, and takes three arguments: the session, the authentication challenge, and a pointer to the credential that should be used to resolve the challenge.

 @warning Implementing a session authentication challenge handler yourself totally bypasses AFNetworking's security policy defined in `AFSecurityPolicy`. Make sure you fully understand the implications before implementing a custom session authentication challenge handler. If you do not want to bypass AFNetworking's security policy, use `-setAuthenticationChallengeHandler:` instead.

 @see -securityPolicy
 @see -setAuthenticationChallengeHandler:
 */
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
- (void)setAuthenticationChallengeHandler:(id (^)(NSURLSession *session, NSURLSessionTask *task, NSURLAuthenticationChallenge *challenge, void (^completionHandler)(NSURLSessionAuthChallengeDisposition , NSURLCredential * _Nullable)))authenticationChallengeHandler;

/**
 Sets a block to be executed periodically to track upload progress, as handled by the `NSURLSessionTaskDelegate` method `URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:`.

 @param block A block object to be called when an undetermined number of bytes have been uploaded to the server. This block has no return value and takes five arguments: the session, the task, the number of bytes written since the last time the upload progress block was called, the total bytes written, and the total bytes expected to be written during the request, as initially determined by the length of the HTTP body. This block may be called multiple times, and will execute on the main thread.
 */
- (void)setTaskDidSendBodyDataBlock:(nullable void (^)(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend))block;

/**
 Sets a block to be executed as the last message related to a specific task, as handled by the `NSURLSessionTaskDelegate` method `URLSession:task:didCompleteWithError:`.

 @param block A block object to be executed when a session task is completed. The block has no return value, and takes three arguments: the session, the task, and any error that occurred in the process of executing the task.
 */
//
- (void)setTaskDidCompleteBlock:(nullable void (^)(NSURLSession *session, NSURLSessionTask *task, NSError * _Nullable error))block;

/**
 Sets a block to be executed when metrics are finalized related to a specific task, as handled by the `NSURLSessionTaskDelegate` method `URLSession:task:didFinishCollectingMetrics:`.

 @param block A block object to be executed when a session task is completed. The block has no return value, and takes three arguments: the session, the task, and any metrics that were collected in the process of executing the task.
 */
#if AF_CAN_INCLUDE_SESSION_TASK_METRICS
- (void)setTaskDidFinishCollectingMetricsBlock:(nullable void (^)(NSURLSession *session, NSURLSessionTask *task, NSURLSessionTaskMetrics * _Nullable metrics))block AF_API_AVAILABLE(ios(10), macosx(10.12), watchos(3), tvos(10));
#endif
///-------------------------------------------
/// @name Setting Data Task Delegate Callbacks
///-------------------------------------------

/**
 Sets a block to be executed when a data task has received a response, as handled by the `NSURLSessionDataDelegate` method `URLSession:dataTask:didReceiveResponse:completionHandler:`.

 @param block A block object to be executed when a data task has received a response. The block returns the disposition of the session response, and takes three arguments: the session, the data task, and the received response.
 */
- (void)setDataTaskDidReceiveResponseBlock:(nullable NSURLSessionResponseDisposition (^)(NSURLSession *session, NSURLSessionDataTask *dataTask, NSURLResponse *response))block;

/**
 Sets a block to be executed when a data task has become a download task, as handled by the `NSURLSessionDataDelegate` method `URLSession:dataTask:didBecomeDownloadTask:`.

 @param block A block object to be executed when a data task has become a download task. The block has no return value, and takes three arguments: the session, the data task, and the download task it has become.
 */
- (void)setDataTaskDidBecomeDownloadTaskBlock:(nullable void (^)(NSURLSession *session, NSURLSessionDataTask *dataTask, NSURLSessionDownloadTask *downloadTask))block;

/**
 Sets a block to be executed when a data task receives data, as handled by the `NSURLSessionDataDelegate` method `URLSession:dataTask:didReceiveData:`.

 @param block A block object to be called when an undetermined number of bytes have been downloaded from the server. This block has no return value and takes three arguments: the session, the data task, and the data received. This block may be called multiple times, and will execute on the session manager operation queue.
 */
- (void)setDataTaskDidReceiveDataBlock:(nullable void (^)(NSURLSession *session, NSURLSessionDataTask *dataTask, NSData *data))block;

/**
 Sets a block to be executed to determine the caching behavior of a data task, as handled by the `NSURLSessionDataDelegate` method `URLSession:dataTask:willCacheResponse:completionHandler:`.

 @param block A block object to be executed to determine the caching behavior of a data task. The block returns the response to cache, and takes three arguments: the session, the data task, and the proposed cached URL response.
 */
- (void)setDataTaskWillCacheResponseBlock:(nullable NSCachedURLResponse * (^)(NSURLSession *session, NSURLSessionDataTask *dataTask, NSCachedURLResponse *proposedResponse))block;

/**
 Sets a block to be executed once all messages enqueued for a session have been delivered, as handled by the `NSURLSessionDelegate` method `URLSessionDidFinishEventsForBackgroundURLSession:`.

 @param block A block object to be executed once all messages enqueued for a session have been delivered. The block has no return value and takes a single argument: the session.
 */
- (void)setDidFinishEventsForBackgroundURLSessionBlock:(nullable void (^)(NSURLSession *session))block AF_API_UNAVAILABLE(macos);

// ——————————————————————— 设置下子任务代理的回调 ——————————————————
/**
 Sets a block to be executed when a download task has completed a download, as handled by the `NSURLSessionDownloadDelegate` method `URLSession:downloadTask:didFinishDownloadingToURL:`.

 @param block A block object to be executed when a download task has completed. The block returns the URL the download should be moved to, and takes three arguments: the session, the download task, and the temporary location of the downloaded file. If the file manager encounters an error while attempting to move the temporary file to the destination, an `AFURLSessionDownloadTaskDidFailToMoveFileNotification` will be posted, with the download task as its object, and the user info of the error.
 */
- (void)setDownloadTaskDidFinishDownloadingBlock:(nullable NSURL * _Nullable  (^)(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, NSURL *location))block;

/**
 Sets a block to be executed periodically to track download progress, as handled by the `NSURLSessionDownloadDelegate` method `URLSession:downloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:`.

 @param block A block object to be called when an undetermined number of bytes have been downloaded from the server. This block has no return value and takes five arguments: the session, the download task, the number of bytes read since the last time the download progress block was called, the total bytes read, and the total bytes expected to be read during the request, as initially determined by the expected content size of the `NSHTTPURLResponse` object. This block may be called multiple times, and will execute on the session manager operation queue.
 */
- (void)setDownloadTaskDidWriteDataBlock:(nullable void (^)(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite))block;

/**
 Sets a block to be executed when a download task has been resumed, as handled by the `NSURLSessionDownloadDelegate` method `URLSession:downloadTask:didResumeAtOffset:expectedTotalBytes:`.

 @param block A block object to be executed when a download task has been resumed. The block has no return value and takes four arguments: the session, the download task, the file offset of the resumed download, and the total number of bytes expected to be downloaded.
 */
- (void)setDownloadTaskDidResumeBlock:(nullable void (^)(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t fileOffset, int64_t expectedTotalBytes))block;

@end

///--------------------
/// @name Notifications
///--------------------

/**
 Posted when a task resumes.
 */
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidResumeNotification;

/**
 Posted when a task finishes executing. Includes a userInfo dictionary with additional information about the task.
 */
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidCompleteNotification;

/**
 Posted when a task suspends its execution.
 */
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidSuspendNotification;

/**
 Posted when a session is invalidated.
 */
FOUNDATION_EXPORT NSString * const AFURLSessionDidInvalidateNotification;

/**
 Posted when a session download task finished moving the temporary download file to a specified destination successfully.
 */
FOUNDATION_EXPORT NSString * const AFURLSessionDownloadTaskDidMoveFileSuccessfullyNotification;

/**
 Posted when a session download task encountered an error when moving the temporary download file to a specified destination.
 */
FOUNDATION_EXPORT NSString * const AFURLSessionDownloadTaskDidFailToMoveFileNotification;

/**
 The raw response data of the task. Included in the userInfo dictionary of the `AFNetworkingTaskDidCompleteNotification` if response data exists for the task.
 */
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidCompleteResponseDataKey;

/**
 The serialized response object of the task. Included in the userInfo dictionary of the `AFNetworkingTaskDidCompleteNotification` if the response was serialized.
 */
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidCompleteSerializedResponseKey;

/**
 The response serializer used to serialize the response. Included in the userInfo dictionary of the `AFNetworkingTaskDidCompleteNotification` if the task has an associated response serializer.
 */
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidCompleteResponseSerializerKey;

/**
 The file path associated with the download task. Included in the userInfo dictionary of the `AFNetworkingTaskDidCompleteNotification` if an the response data has been stored directly to disk.
 */
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidCompleteAssetPathKey;

/**
 Any error associated with the task, or the serialization of the response. Included in the userInfo dictionary of the `AFNetworkingTaskDidCompleteNotification` if an error exists.
 */
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidCompleteErrorKey;

/**
 The session task metrics taken from the download task. Included in the userInfo dictionary of the `AFNetworkingTaskDidCompleteSessionTaskMetrics`
 */
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidCompleteSessionTaskMetrics;

NS_ASSUME_NONNULL_END
