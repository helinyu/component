//  验证

NS_ASSUME_NONNULL_BEGIN

/*!
    @enum NSURLCredentialPersistence
    @abstract Constants defining how long a credential will be kept around
    @constant NSURLCredentialPersistenceNone 验证不保持
    @constant NSURLCredentialPersistenceForSession 验证存放在session
    @constant NSURLCredentialPersistencePermanent 验证将会永久存储。注意：mac os X 应用能够访问任何验证提供给用户许可，iphone os应用能够只访问它自己的验证。   
    @constant NSURLCredentialPersistenceSynchronizable 持久存储，额外，这个证书将会被芬达到其他appleID的设备 
*/


//  验证持有
typedef NS_ENUM(NSUInteger, NSURLCredentialPersistence) {
    NSURLCredentialPersistenceNone,
    NSURLCredentialPersistenceForSession, // session
    NSURLCredentialPersistencePermanent, // 永久
    NSURLCredentialPersistenceSynchronizable API_AVAILABLE(macos(10.8), ios(6.0), watchos(2.0), tvos(9.0)) // 同步
};

@class NSURLCredentialInternal;


// 表示一个授权验证。 
//  验证确定构造的范畴在下面
API_AVAILABLE(macos(10.2), ios(2.0), watchos(2.0), tvos(9.0))
@interface NSURLCredential : NSObject <NSSecureCoding, NSCopying>
{
    @private
    __strong NSURLCredentialInternal *_internal;
}

//   持久
@property (readonly) NSURLCredentialPersistence persistence;

@end


//  用户密码验证
@interface NSURLCredential(NSInternetPassword)

- (instancetype)initWithUser:(NSString *)user password:(NSString *)password persistence:(NSURLCredentialPersistence)persistence;

/*!
    @param user 用户
    @param password 密码
    @param persistence 持久或者不
*/
+ (NSURLCredential *)credentialWithUser:(NSString *)user password:(NSString *)password persistence:(NSURLCredentialPersistence)persistence;

//  用户、密码
@property (nullable, readonly, copy) NSString *user;
@property (nullable, readonly, copy) NSString *password;

//  是否有密码
@property (readonly) BOOL hasPassword;

@end

//  这个分类定义的方法适用于创建表示一个客户端的证书验证
// 客户端证书公共存储在keychain， 必须在握手的时候处理。
//  客户端证书验证
@interface NSURLCredential(NSClientCertificate)

/*!
    @method initWithIdentity:certificates:persistence:
    // 至少有一个客户端证书
    @param identity a SecIdentityRef object
    @param certArray 证书引用的数组
    @param persistence 持久的方式
    @result the Initialized NSURLCredential
 */
- (instancetype)initWithIdentity:(SecIdentityRef)identity certificates:(nullable NSArray *)certArray persistence:(NSURLCredentialPersistence)persistence API_AVAILABLE(macos(10.6), ios(3.0), watchos(2.0), tvos(9.0));

/*! 
    @param identity  标识
    @param certArray 验证证书
    @param persistence 持久的枚举
 */
+ (NSURLCredential *)credentialWithIdentity:(SecIdentityRef)identity certificates:(nullable NSArray *)certArray persistence:(NSURLCredentialPersistence)persistence API_AVAILABLE(macos(10.6), ios(3.0), watchos(2.0), tvos(9.0));

@property (nullable, readonly) SecIdentityRef identity; // 标识符

//  证书
@property (readonly, copy) NSArray *certificates API_AVAILABLE(macos(10.6), ios(3.0), watchos(2.0), tvos(9.0));

@end

@interface NSURLCredential(NSServerTrust)

//   服务器的验证
- (instancetype)initWithTrust:(SecTrustRef)trust API_AVAILABLE(macos(10.6), ios(3.0), watchos(2.0), tvos(9.0));
+ (NSURLCredential *)credentialForTrust:(SecTrustRef)trust API_AVAILABLE(macos(10.6), ios(3.0), watchos(2.0), tvos(9.0));

@end

NS_ASSUME_NONNULL_END

PS： 这三种类型的验证可以查看
// https://www.cnblogs.com/code-life/p/7806824.html 连接