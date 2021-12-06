

//  验证的缓存

API_AVAILABLE(macos(10.2), ios(2.0), watchos(2.0), tvos(9.0))
@interface NSURLCredentialStorage : NSObject
{
    @private
    NSURLCredentialStorageInternal *_internal;
}
//  摸摸人的换一个对象
@property (class, readonly, strong) NSURLCredentialStorage *sharedCredentialStorage;


//  通过保护域获取验证
- (nullable NSDictionary<NSString *, NSURLCredential *> *)credentialsForProtectionSpace:(NSURLProtectionSpace *)space;

//  所有的验证
@property (readonly, copy) NSDictionary<NSURLProtectionSpace *, NSDictionary<NSString *, NSURLCredential *> *> *allCredentials;

// 设置证书给对应的空间
- (void)setCredential:(NSURLCredential *)credential forProtectionSpace:(NSURLProtectionSpace *)space;

//  移除对应保护空间的证书
- (void)removeCredential:(NSURLCredential *)credential forProtectionSpace:(NSURLProtectionSpace *)space;
- (void)removeCredential:(NSURLCredential *)credential forProtectionSpace:(NSURLProtectionSpace *)space options:(nullable NSDictionary<NSString *, id> *)options API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0));

//  默认的证书
- (nullable NSURLCredential *)defaultCredentialForProtectionSpace:(NSURLProtectionSpace *)space;

//  设置默认的证书
- (void)setDefaultCredential:(NSURLCredential *)credential forProtectionSpace:(NSURLProtectionSpace *)space;

@end

//  session task 可能会使用到的方法
@interface NSURLCredentialStorage (NSURLSessionTaskAdditions)
- (void)getCredentialsForProtectionSpace:(NSURLProtectionSpace *)protectionSpace task:(NSURLSessionTask *)task completionHandler:(void (^) (NSDictionary<NSString *, NSURLCredential *> * _Nullable credentials))completionHandler API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0)) NS_SWIFT_ASYNC_NAME(credentials(for:task:));
- (void)setCredential:(NSURLCredential *)credential forProtectionSpace:(NSURLProtectionSpace *)protectionSpace task:(NSURLSessionTask *)task API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));
- (void)removeCredential:(NSURLCredential *)credential forProtectionSpace:(NSURLProtectionSpace *)protectionSpace options:(nullable NSDictionary<NSString *, id> *)options task:(NSURLSessionTask *)task API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));
- (void)getDefaultCredentialForProtectionSpace:(NSURLProtectionSpace *)space task:(NSURLSessionTask *)task completionHandler:(void (^) (NSURLCredential * _Nullable credential))completionHandler API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));
- (void)setDefaultCredential:(NSURLCredential *)credential forProtectionSpace:(NSURLProtectionSpace *)protectionSpace task:(NSURLSessionTask *)task API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));
@end

//  验证存储改变通知
FOUNDATION_EXPORT NSNotificationName const NSURLCredentialStorageChangedNotification API_AVAILABLE(macos(10.2), ios(2.0), watchos(2.0), tvos(9.0));

// 移除同步验证
FOUNDATION_EXPORT NSString *const NSURLCredentialStorageRemoveSynchronizableCredentials API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0));

NS_ASSUME_NONNULL_END
