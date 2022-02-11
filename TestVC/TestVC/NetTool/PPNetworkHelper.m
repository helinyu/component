//
//                                  _oo8oo_
//                                 o8888888o
//                                 88" . "88
//                                 (| -_- |)
//                                 0\  =  /0
//                               ___/'==='\___
//                             .' \\|     |// '.
//                            / \\|||  :  |||// \
//                           / _||||| -:- |||||_ \
//                          |   | \\\  -  /// |   |
//                          | \_|  ''\---/''  |_/ |
//                          \  .-\__  '-'  __/-.  /
//                        ___'. .'  /--.--\  '. .'___
//                     ."" '<  '.___\_<|>_/___.'  >' "".
//                    | | :  `- \`.:`\ _ /`:.`/ -`  : | |
//                    \  \ `-.   \_ __\ /__ _/   .-` /  /
//                =====`-.____`.___ \_____/ ___.`____.-`=====
//                                  `=---=`
//
//
//               ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
//                          佛祖保佑         永无bug

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCellularData.h>

#import "PPNetworkHelper.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <NSDictionary+YYAdd.h>

//#import "KMHTTPRequestSerializer.h"
//#import "KMJSONRequestSerializer.h"

//#import "KMShowDataManager.h"
//#import "WKInterFaceRetryManager.h"
//#import "HTTPDNSManager.h"
//#import "NSString+Extend.h"
//#import "XNHomeDataManager.h"

#ifdef DEBUG
#define PPLog(...) printf("[%s] %s [第%d行]: %s\n", __TIME__ ,__PRETTY_FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#define PPLog(...)
#endif


#define kTimeOut   (10.0f)

@implementation PPNetworkHelper

static AFHTTPSessionManager *_sessionManager;
static NSMutableArray *_allSessionTask;
static NSString *_version;

#pragma mark - WWAN网络状态
+ (NSString *)wwanNetworkStatus{
    NSArray *typeStrings2G = @[CTRadioAccessTechnologyEdge,
                               CTRadioAccessTechnologyGPRS,
                               CTRadioAccessTechnologyCDMA1x];
    
    NSArray *typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                               CTRadioAccessTechnologyWCDMA,
                               CTRadioAccessTechnologyHSUPA,
                               CTRadioAccessTechnologyCDMAEVDORev0,
                               CTRadioAccessTechnologyCDMAEVDORevA,
                               CTRadioAccessTechnologyCDMAEVDORevB,
                               CTRadioAccessTechnologyeHRPD];
    
    NSArray *typeStrings4G = @[CTRadioAccessTechnologyLTE];
    
    CTTelephonyNetworkInfo *teleInfo= [[CTTelephonyNetworkInfo alloc] init];
    NSString *accessString = teleInfo.currentRadioAccessTechnology;
    if ([typeStrings4G containsObject:accessString]) {
        return @"4G";
    } else if ([typeStrings3G containsObject:accessString]) {
        return @"3G";
    } else if ([typeStrings2G containsObject:accessString]) {
        return @"2G";
    }
    return NSLocalizedString(@"OffLine", @"离线");
}
 
#pragma mark - 开始监听网络
+ (void)networkStatusWithBlock:(NetworkStatus)networkStatus
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
        [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status)
            {
                case AFNetworkReachabilityStatusUnknown:
                    networkStatus ? networkStatus(PPNetworkStatusUnknown) : nil;
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    networkStatus ? networkStatus(PPNetworkStatusNotReachable) : nil;
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    networkStatus ? networkStatus(PPNetworkStatusReachableViaWWAN) : nil;
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    networkStatus ? networkStatus(PPNetworkStatusReachableViaWiFi) : nil;
                    break;
            }
        }];
        
        [reachabilityManager startMonitoring];
    });
}

+ (BOOL)isNetwork
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)isWWANNetwork
{
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

+ (BOOL)isWiFiNetwork
{
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

+ (void)cancelAllRequest
{
    // 锁操作
    @synchronized(self)
    {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self allSessionTask] removeAllObjects];
    }
}

+ (void)cancelRequestWithURL:(NSString *)URL
{
    if (!URL) { return; }
    @synchronized (self)
    {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [[self allSessionTask] removeObject:task];
                *stop = YES;
            }
        }];
    }
}

#pragma mark -
+ (NSURLSessionTask *)methodName:(NSString *)methodName
                             URL:(NSString *)URL
                      parameters:(NSDictionary *)parameters
                         success:(HttpRequestSuccess)success
                         failure:(HttpRequestFailed)failure
{
    NSString * uppercaseStr = [methodName uppercaseString];
    if ([uppercaseStr isEqualToString:@"GET"])
    {
        return [self GET:URL parameters:parameters responseCache:nil success:success failure:failure];
    }
    else if ([uppercaseStr isEqualToString:@"POST"])
    {
        return [self POST:URL parameters:parameters responseCache:nil success:success failure:failure];
    }
    return nil;
}

#pragma mark - GET请求无缓存

+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(NSDictionary *)parameters
                  success:(HttpRequestSuccess)success
                  failure:(HttpRequestFailed)failure
{
    return [self GET:URL parameters:parameters responseCache:nil success:success failure:failure];
}


#pragma mark - POST请求无缓存

+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(NSDictionary *)parameters
                   success:(HttpRequestSuccess)success
                   failure:(HttpRequestFailed)failure
{
    return [self POST:URL parameters:parameters responseCache:nil success:success failure:failure];
}

#pragma mark - GET请求 带重试次数

+ (__kindof NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(NSDictionary *)parameters
                        retryCount:(NSInteger)retryCount
                     responseCache:(HttpRequestCache)responseCache
                           success:(HttpRequestSuccess)success
                           failure:(HttpRequestFailed)failure
{
    NSParameterAssert(URL);
    
    //需要添加广告数据的URL
    NSString * ADSDataURL = URL;
//
//    if ([URL hasPrefix:@"http://"] || [URL hasPrefix:@"https://"]) {
//
//    }else{
//        URL = [KMConfigManager getInterfaceAddress:URL];
//    }
//
    NSString *newUrl = URL;
    
    NSString *ipUrl = newUrl;
    
    parameters = [self parseNewParameters:parameters url:ipUrl]; //加入全局元素
    
    //读取缓存
    responseCache ? responseCache([PPNetworkCache httpCacheForURL:newUrl parameters:parameters]) : nil;
    
    NSURLSessionTask *sessionTask = [_sessionManager GET:ipUrl parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self allSessionTask] removeObject:task];
     
//        id resultObject = [KMShowDataManager addADSDataWithURL:ADSDataURL parameters:parameters responseObject:responseObject];
        !success? :success(responseObject);
        responseCache ? [PPNetworkCache setHttpCache:responseObject URL:[self cacheUrl:newUrl] parameters:parameters] : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[self allSessionTask] removeObject:task];
        if (retryCount > 0) {
            [self GET:ipUrl parameters:parameters retryCount:retryCount - 1 responseCache:responseCache success:success failure:failure];
        }
        else
        {
            failure ? failure([NSError errorWithDomain:@"网络错误" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"网络错误"}]) : nil;
        }
        
        //[self processNetworkFailed];
    }];
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}



#pragma mark - GET请求自动缓存
+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(NSDictionary *)parameters
            responseCache:(HttpRequestCache)responseCache
                  success:(HttpRequestSuccess)success
                  failure:(HttpRequestFailed)failure
{
    return [self GET:URL parameters:parameters retryCount:0 responseCache:responseCache success:success failure:failure];
}

+ (NSString *)cacheUrl:(NSString *)url{
    if ([url containsString:@"refreshTime="]) {
        NSRange range = [url rangeOfString:@"?"];
        NSString *paramStr = [url substringFromIndex:range.location + 1];
        NSArray *paramList = [paramStr componentsSeparatedByString:@"&"];
        for (NSString *param in paramList) {
            if ([param containsString:@"refreshTime="]) {
                NSString *newUrl = [url stringByReplacingOccurrencesOfString:param withString:@""];
                newUrl = [newUrl substringToIndex:newUrl.length - 1];
                return newUrl;
            }
        }
    }
    return url;
}

#pragma mark - POST请求自动缓存 可设置重试次数

+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                         retryCount:(NSInteger)retryCount
                      responseCache:(HttpRequestCache)responseCache
                            success:(HttpRequestSuccess)success
                            failure:(HttpRequestFailed)failure
{
    NSParameterAssert(URL);
    
    //需要添加广告数据的URL
    NSString * ADSDataURL = URL;
    [self setHttpHeaderWithURL:URL];
    
    NSString *ipUrl = URL;
    NSString *conditionRetryURL = ipUrl;
    
    //读取缓存
    responseCache ? responseCache([PPNetworkCache httpCacheForURL:URL parameters:parameters]) : nil;
    //_sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *newParams = [self newParameters:parameters];
    
    newParams = [self parseNewParameters:newParams url:ipUrl]; //加入全局元素

    NSURLSessionTask *sessionTask = [_sessionManager POST:ipUrl parameters:newParams headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self allSessionTask] removeObject:task];
        
        success ? success(responseObject) : nil;
        //对数据进行异步缓存
        responseCache ? [PPNetworkCache setHttpCache:responseObject URL:URL parameters:parameters] : nil;
        
//        //需要重试的接口会生成新参数
//        NSMutableDictionary * retryParameters = [WKInterFaceRetryManager retryWithURL:conditionRetryURL parameters:parameters responseObject:responseObject];
//
//        //条件重试的时候 不发生回调，必须得到下次发生后才回调
//        if (!retryParameters) {
//            //retry 的时候 不进行下列处理 retry优先级最高
//            id resultObject = [KMShowDataManager addADSDataWithURL:ADSDataURL parameters:parameters responseObject:responseObject];
//            success ? success(responseObject) : nil;
//            //对数据进行异步缓存
//            responseCache ? [PPNetworkCache setHttpCache:responseObject URL:URL parameters:parameters] : nil;
//        }
//        else
//        {
//            [self POST:conditionRetryURL parameters:retryParameters success:success failure:failure];
//        }
        //        responseCache ? [PPNetworkCache setHttpCache:responseObject URL:URL parameters:parameters] : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[self allSessionTask] removeObject:task];
        if (retryCount > 0) {
            [self POST:URL parameters:parameters retryCount:retryCount - 1 responseCache:responseCache success:success failure:failure];
        }
        else
        {
            failure ? failure(error) : nil;
        }
        //[self processNetworkFailed];
    }];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    return sessionTask;
}

#pragma mark - POST请求自动缓存

+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(NSDictionary *)parameters
             responseCache:(HttpRequestCache)responseCache
                   success:(HttpRequestSuccess)success
                   failure:(HttpRequestFailed)failure
{
    return [self POST:URL parameters:parameters retryCount:0 responseCache:responseCache success:success failure:failure];
}

+ (NSDictionary *)newParameters:(NSDictionary *)parameters{
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [parms setObject:@"appstore" forKey:@"client-channel"];
    [parms setObject:(@"iphone") forKey:@"client-type"];
    [parms setObject:_version forKey:@"client-version"];
    CGFloat timeSpan = [NSDate date].timeIntervalSince1970 * 1000;
    [parms setObject:[NSString stringWithFormat:@"%.f",timeSpan] forKey:@"localtime"];
    [parms setObject:@(1) forKey:@"userloglevel"];

    return parms;
}


+(NSDictionary *)parseNewParameters:(NSDictionary *)parameters url:(NSString *)url
{
    NSMutableDictionary *newParameters = [NSMutableDictionary dictionaryWithCapacity:0];
    if (parameters) {
        [newParameters addEntriesFromDictionary:parameters];
    }
    
    if (![newParameters containsObjectForKey:@"uid"] && ![url containsString:@"uid="]) {
//        if (kUserId) {
//            [newParameters setObject:@(kUserId) forKey:@"uid"];
//        }
    }
    
    if (![newParameters containsObjectForKey:@"udid"] && ![url containsString:@"udid="]) {
        [newParameters setObject:@"" forKey:@"udid"];
    }
    
    if (![newParameters containsObjectForKey:@"version"] && ![url containsString:@"version="]) {
        [newParameters setObject:_version forKey:@"version"];
    }
    
    if (![newParameters containsObjectForKey:@"platform"] && ![url containsString:@"platform="]) {
        [newParameters setObject:@"ios" forKey:@"platform"];
    }
    
    if (![newParameters containsObjectForKey:@"platformname"] && ![url containsString:@"platformname="]) {
        [newParameters setObject:@"iphone" forKey:@"platformname"];
    }
    
    if (![newParameters containsObjectForKey:@"productname"] && ![url containsString:@"productname="]) {
        [newParameters setObject:@"" forKey:@"productname"];
    }
    
    if (![newParameters containsObjectForKey:@"client-channel"] && ![url containsString:@"client-channel="]) {
        [newParameters setObject:@"appstore" forKey:@"client-channel"];
    }
    
    if (![newParameters containsObjectForKey:@"area"] && ![url containsString:@"area="]) {
        [newParameters setObject:@"" forKey:@"area"];
    }
    
    //加入性别
    if (![newParameters containsObjectForKey:@"gender"] && ![url containsString:@"gender="]) {
        [newParameters setObject:@(1) forKey:@"gender"];
    }
    
    //兼容之前处理，加入myuid
    if (![newParameters containsObjectForKey:@"myuid"] && ![url containsString:@"myuid="]) {
            [newParameters setObject:@(0) forKey:@"myuid"];
    }
    
//    //加入sessionid
//    if (![newParameters containsObjectForKey:@"sessionid"] && ![url containsString:@"sessionid="]) {
//        NSString *access_session_id = [MkzZymkStatisticsManager zymkAccess_session_id];
//        if (access_session_id) {
//            [newParameters setObject:access_session_id forKey:@"sessionid"];
//        }
//    }
//
//    //3.3.20
//    if (![newParameters containsObjectForKey:@"vip_form"] && ![url containsString:@"vip_form="]) {
//        if (kUserId) {
//            [newParameters setObject:@(kMainUser.vip_form) forKey:@"vip_form"];
//        }
//    }
    
    return newParameters;
}


+ (NSString *)newArrayUrlWith:(NSString *)url property:(NSDictionary *)property{
    NSMutableArray *arrayValues = [NSMutableArray new];
    NSArray *keys = [property allKeys];
    for (id key in keys) {
        id values = [property objectForKey:key];
        if ([values isKindOfClass:[NSArray class]]) {
            for (id value in values) {
                if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
                    [arrayValues addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
                }
            }
        }
    }
    if (arrayValues.count > 0) {
        NSString *arrayStr = [arrayValues componentsJoinedByString:@"&"];
        NSString *tail = @"";
        if ([url containsString:@"?"]) {
            if ([url hasSuffix:@"?"]) {
                tail = @"";
            }
            else{
                tail = @"&";
            }
        }
        else{
            tail = @"?";
        }
        url = [url stringByAppendingFormat:@"%@%@", tail, arrayStr];
    }
    return url;
};



+ (void)setHttpHeaderWithURL:(NSString *)url{
//    NSString *taskAuthCode = kMainUser.taskAuthCode;
//    if ([self isTaskURL:url] && taskAuthCode.length > 0) {
//        //添加任务验证
//        NSString * taskAuth = [@"Bearer " stringByAppendingString:taskAuthCode];
//        [_sessionManager.requestSerializer setValue:taskAuth forHTTPHeaderField:@"Authorization"];
//    }
}


+ (BOOL)isTaskURL:(NSString *)URL
{
//    NSArray * tasks = @[GetTaskList,FinishTask];
//    for (NSString * task in tasks) {
//        if ([URL containsString:task]) {
//            return YES;
//        }
//    }
    return NO;
}

#pragma mark - 上传图片文件

+ (NSURLSessionTask *)uploadWithURL:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                             images:(NSArray<UIImage *> *)images
                               name:(NSString *)name
                           fileName:(NSString *)fileName
                           mimeType:(NSString *)mimeType
                           progress:(HttpProgress)progress
                            success:(HttpRequestSuccess)success
                            failure:(HttpRequestFailed)failure
{
    
    NSString *ipUrl = URL;
    
    NSDictionary *newParams = [self newParameters:parameters];
    
    newParams = [self parseNewParameters:newParams url:ipUrl]; //加入全局元素
    
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:newParams headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //压缩-添加-上传图片
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            [formData appendPartWithFileData:imageData name:name fileName:[NSString stringWithFormat:@"%@%lu.%@",fileName,(unsigned long)idx,mimeType?mimeType:@"jpeg"] mimeType:[NSString stringWithFormat:@"image/%@",mimeType ? mimeType : @"jpeg"]];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[self allSessionTask] removeObject:task];
        
        failure ? failure(error) : nil;
        
    }];
    
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}


+ (NSURLSessionTask *)uploadWithURL:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                             images:(NSArray<UIImage *> *)images
                               name:(NSString *)name
                         fileSuffix:(NSString *)fileSuffix
                           mimeType:(NSString *)mimeType
                           progress:(HttpProgress)progress
                            success:(HttpRequestSuccess)success
                            failure:(HttpRequestFailed)failure {
    
    NSString *ipUrl = URL;
    
    NSDictionary *newParams = [self newParameters:parameters];
    
    newParams = [self parseNewParameters:newParams url:ipUrl]; //加入全局元素
    
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:newParams headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //压缩-添加-上传图片
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
//            [formData appendPartWithFileData:imageData name:name fileName:[NSString stringWithFormat:@"%@.%@",[NSUUID UUID].UUIDString, fileSuffix] mimeType:[NSString stringWithFormat:@"%@",mimeType ? mimeType : kDefaultMineType]];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[self allSessionTask] removeObject:task];
        
        failure ? failure(error) : nil;
        
    }];
    
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}


+ (__kindof NSURLSessionTask *)uploadWithURL:(NSString *)URL
                                  parameters:(NSDictionary *)parameters
                                        file:(id)file
                                        name:(NSString *)name
                                    fileName:(NSString *)fileName
                                    mimeType:(NSString *)mimeType
                                    progress:(HttpProgress)progress
                                     success:(HttpRequestSuccess)success
                                     failure:(HttpRequestFailed)failure
{
    
    NSString *ipUrl = URL;
    
    NSDictionary *newParams = [self newParameters:parameters];
    
    newParams = [self parseNewParameters:newParams url:ipUrl]; //加入全局元素
    
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:newParams headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *fileData = file;
        if ([file isKindOfClass:[NSString class]]) {
            fileData = [NSData dataWithContentsOfFile:file];
        }
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[self allSessionTask] removeObject:task];
        
        failure ? failure(error) : nil;
        
    }];
    
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}


#pragma mark - 下载文件
+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                              fileDir:(NSString *)fileDir
                             progress:(HttpProgress)progress
                              success:(void(^)(NSString *))success
                              failure:(HttpRequestFailed)failure
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    __block NSURLSessionDownloadTask *downloadTask = [_sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //下载进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(downloadProgress) : nil;
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [[self allSessionTask] removeObject:downloadTask];
        if(failure && error) {failure(error) ; return ;};
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
        
    }];
    
    //开始下载
    [downloadTask resume];
    
    // 添加sessionTask到数组
    downloadTask ? [[self allSessionTask] addObject:downloadTask] : nil ;
    return downloadTask;
}

/**
 *  json转字符串
 */
+ (NSString *)jsonToString:(id)data
{
    if(!data) { return nil; }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/**
 存储着所有的请求task数组
 */
+ (NSMutableArray *)allSessionTask
{
    if (!_allSessionTask)
    {
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
}
#pragma mark - 初始化AFHTTPSessionManager相关属性
/**
 *  所有的HTTP请求共享一个AFHTTPSessionManager,原理参考地址:http://www.jianshu.com/p/5969bbb4af9f
 *  + (void)initialize该初始化方法在当用到此类时候只调用一次
 */
+ (void)initialize
{
//    _sessionManager = [AFHTTPSessionManager manager];
    //改为没有缓存的模式
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    _sessionManager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:config];
   
    [self resetInitSessionConfig];
}

+ (void)resetInitSessionConfig {
    // 设置请求参数的类型:JSON (AFJSONRequestSerializer,AFHTTPRequestSerializer)
    _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置请求的超时时间
    [_sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    _sessionManager.requestSerializer.timeoutInterval = kTimeOut;
    [_sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    // 设置服务器返回结果的类型:JSON (AFJSONResponseSerializer,AFHTTPResponseSerializer)
    _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*",@"application/x-javascript",@"application/x-www-form-urlencoded", nil];

    // 打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    _sessionManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    NSDictionary *dict = [NSBundle mainBundle].infoDictionary;
    _version = dict[@"CFBundleShortVersionString"];
    
//    [MkzZymkStatisticsManager zymkHttpHeaderField:_sessionManager.requestSerializer];
}

#pragma mark - 重置AFHTTPSessionManager相关属性
+ (void)setRequestSerializer:(PPRequestSerializer)requestSerializer
{
    _sessionManager.requestSerializer = requestSerializer==PPRequestSerializerHTTP ? [AFJSONRequestSerializer serializer] : [AFJSONRequestSerializer serializer];
    [self setRequestTimeoutInterval:kTimeOut];
//    [MkzZymkStatisticsManager zymkHttpHeaderField:_sessionManager.requestSerializer];
}

+ (void)setResponseSerializer:(PPResponseSerializer)responseSerializer
{
    _sessionManager.responseSerializer = responseSerializer==PPResponseSerializerHTTP ? [AFHTTPResponseSerializer serializer] : [AFJSONResponseSerializer serializer];
}

+ (void)setRequestTimeoutInterval:(NSTimeInterval)time
{
    [_sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    _sessionManager.requestSerializer.timeoutInterval = time;
    [_sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
}

+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field
{
    [_sessionManager.requestSerializer setValue:value forHTTPHeaderField:field];
}

+ (void)openNetworkActivityIndicator:(BOOL)open
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:open];
}

+ (BOOL) configureProxies
{
    NSDictionary *proxySettings = CFBridgingRelease(CFNetworkCopySystemProxySettings());
    
    NSArray *proxies = nil;
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://api.m.taobao.com"];
    
    proxies = CFBridgingRelease(CFNetworkCopyProxiesForURL((__bridge CFURLRef)url,
                                                           (__bridge CFDictionaryRef)proxySettings));
    if (proxies.count > 0)
    {
        NSDictionary *settings = [proxies objectAtIndex:0];
        NSString *host = [settings objectForKey:(NSString *)kCFProxyHostNameKey];
        NSString *port = [settings objectForKey:(NSString *)kCFProxyPortNumberKey];
        
        if (host || port)
        {
            return YES;
        }
    }
    return NO;
}

+ (NSArray *)noNeedPlatfromNameURLs
{
    static NSArray * whiteList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        whiteList = @[GetADsAnnouncement];
    });
    return whiteList;
}

@end


#pragma mark - NSDictionary,NSArray的分类
/*
 ************************************************************************************
 *新建NSDictionary与NSArray的分类, 控制台打印json数据中的中文
 ************************************************************************************
 */

#ifdef DEBUG
@implementation NSArray (PP)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    
    [strM appendString:@")"];
    
    return strM;
}

@end

@implementation NSDictionary (PP)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    [strM appendString:@"}\n"];
    
    return strM;
}
@end
#endif

