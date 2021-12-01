

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

/*!
 @method removeCredential:forProtectionSpace:options
 @abstract Remove the credential from the set for the specified protection space based on options.
 @param credential The credential to remove.
 @param space The protection space for which a credential should be removed
 @param options A dictionary containing options to consider when removing the credential.  This should
 be used when trying to delete a credential that has the NSURLCredentialPersistenceSynchronizable policy.
 Please note that when NSURLCredential objects that have a NSURLCredentialPersistenceSynchronizable policy
 are removed, the credential will be removed on all devices that contain this credential.
 @discussion The credential is removed from both persistent and temporary storage.
 */
- (void)removeCredential:(NSURLCredential *)credential forProtectionSpace:(NSURLProtectionSpace *)space options:(nullable NSDictionary<NSString *, id> *)options API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0));

/*!
    @method defaultCredentialForProtectionSpace:
    @abstract Get the default credential for the specified protection space.
    @param space The protection space for which to get the default credential.
*/
- (nullable NSURLCredential *)defaultCredentialForProtectionSpace:(NSURLProtectionSpace *)space;

/*!
    @method setDefaultCredential:forProtectionSpace:
    @abstract Set the default credential for the specified protection space.
    @param credential The credential to set as default.
    @param space The protection space for which the credential should be set as default.
    @discussion If the credential is not yet in the set for the protection space, it will be added to it.
*/
- (void)setDefaultCredential:(NSURLCredential *)credential forProtectionSpace:(NSURLProtectionSpace *)space;

@end

@interface NSURLCredentialStorage (NSURLSessionTaskAdditions)
- (void)getCredentialsForProtectionSpace:(NSURLProtectionSpace *)protectionSpace task:(NSURLSessionTask *)task completionHandler:(void (^) (NSDictionary<NSString *, NSURLCredential *> * _Nullable credentials))completionHandler API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0)) NS_SWIFT_ASYNC_NAME(credentials(for:task:));
- (void)setCredential:(NSURLCredential *)credential forProtectionSpace:(NSURLProtectionSpace *)protectionSpace task:(NSURLSessionTask *)task API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));
- (void)removeCredential:(NSURLCredential *)credential forProtectionSpace:(NSURLProtectionSpace *)protectionSpace options:(nullable NSDictionary<NSString *, id> *)options task:(NSURLSessionTask *)task API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));
- (void)getDefaultCredentialForProtectionSpace:(NSURLProtectionSpace *)space task:(NSURLSessionTask *)task completionHandler:(void (^) (NSURLCredential * _Nullable credential))completionHandler API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));
- (void)setDefaultCredential:(NSURLCredential *)credential forProtectionSpace:(NSURLProtectionSpace *)protectionSpace task:(NSURLSessionTask *)task API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));
@end

/*!
    @const NSURLCredentialStorageChangedNotification
    @abstract This notification is sent on the main thread whenever
    the set of stored credentials changes.
*/
FOUNDATION_EXPORT NSNotificationName const NSURLCredentialStorageChangedNotification API_AVAILABLE(macos(10.2), ios(2.0), watchos(2.0), tvos(9.0));

/*
 *  NSURLCredentialStorageRemoveSynchronizableCredentials - (NSNumber value)
 *		A key that indicates either @YES or @NO that credentials which contain the NSURLCredentialPersistenceSynchronizable
 *		attribute should be removed.  If the key is missing or the value is @NO, then no attempt will be made
 *		to remove such a credential.
 */
FOUNDATION_EXPORT NSString *const NSURLCredentialStorageRemoveSynchronizableCredentials API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0));

NS_ASSUME_NONNULL_END
