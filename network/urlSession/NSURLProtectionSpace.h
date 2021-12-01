/*	
    NSURLProtectionSpace.h
    Copyright (c) 2003-2019, Apple Inc. All rights reserved.    
    
    Public header file.
*/

#import <Foundation/NSObject.h>
#import <Security/Security.h>

@class NSString;
@class NSArray<ObjectType>;
@class NSData;

NS_ASSUME_NONNULL_BEGIN


FOUNDATION_EXPORT NSString * const NSURLProtectionSpaceHTTP API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));
FOUNDATION_EXPORT NSString * const NSURLProtectionSpaceHTTPS API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));
FOUNDATION_EXPORT NSString * const NSURLProtectionSpaceFTP API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));
FOUNDATION_EXPORT NSString * const NSURLProtectionSpaceHTTPProxy API_AVAILABLE(macos(10.2), ios(2.0), watchos(2.0), tvos(9.0));
FOUNDATION_EXPORT NSString * const NSURLProtectionSpaceHTTPSProxy API_AVAILABLE(macos(10.2), ios(2.0), watchos(2.0), tvos(9.0));
FOUNDATION_EXPORT NSString * const NSURLProtectionSpaceFTPProxy API_AVAILABLE(macos(10.2), ios(2.0), watchos(2.0), tvos(9.0));
FOUNDATION_EXPORT NSString * const NSURLProtectionSpaceSOCKSProxy API_AVAILABLE(macos(10.2), ios(2.0), watchos(2.0), tvos(9.0))
FOUNDATION_EXPORT NSString * const NSURLAuthenticationMethodDefault API_AVAILABLE(macos(10.2), ios(2.0), watchos(2.0), tvos(9.0));


FOUNDATION_EXPORT NSString * const NSURLAuthenticationMethodHTTPBasic API_AVAILABLE(macos(10.2), ios(2.0), watchos(2.0), tvos(9.0));
FOUNDATION_EXPORT NSString * const NSURLAuthenticationMethodHTTPDigest API_AVAILABLE(macos(10.2), ios(2.0), watchos(2.0), tvos(9.0));
FOUNDATION_EXPORT NSString * const NSURLAuthenticationMethodHTMLForm API_AVAILABLE(macos(10.2), ios(2.0), watchos(2.0), tvos(9.0));
FOUNDATION_EXPORT NSString * const NSURLAuthenticationMethodNTLM API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));
FOUNDATION_EXPORT NSString * const NSURLAuthenticationMethodNegotiate API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));
FOUNDATION_EXPORT NSString * const NSURLAuthenticationMethodClientCertificate API_AVAILABLE(macos(10.6), ios(3.0), watchos(2.0), tvos(9.0));
FOUNDATION_EXPORT NSString * const NSURLAuthenticationMethodServerTrust API_AVAILABLE(macos(10.6), ios(3.0), watchos(2.0), tvos(9.0));

@class NSURLProtectionSpaceInternal;

API_AVAILABLE(macos(10.2), ios(2.0), watchos(2.0), tvos(9.0))
@interface NSURLProtectionSpace : NSObject <NSSecureCoding, NSCopying>
{
@private
    NSURLProtectionSpaceInternal *_internal;
}

//  初始化主机、代理主机的保护空间
- (instancetype)initWithHost:(NSString *)host port:(NSInteger)port protocol:(nullable NSString *)protocol realm:(nullable NSString *)realm authenticationMethod:(nullable NSString *)authenticationMethod;
- (instancetype)initWithProxyHost:(NSString *)host port:(NSInteger)port type:(nullable NSString *)type realm:(nullable NSString *)realm  authenticationMethod:(nullable NSString *)authenticationMethod;

//  realm是ProtectionSpace的标示符，服务器上的一组资源通过realm来标示成一组采用相同验证方式的资源(ProtectionSpace)。
@property (nullable, readonly, copy) NSString *realm;

@property (readonly) BOOL receivesCredentialSecurely; // 递归验证安全
@property (readonly) BOOL isProxy; // 代理
@property (readonly, copy) NSString *host; // 主机
@property (readonly) NSInteger port; // 端口
@property (nullable, readonly, copy) NSString *proxyType; // 代理类型
@property (nullable, readonly, copy) NSString *protocol; // 接口
@property (readonly, copy) NSString *authenticationMethod; // 验证方法

@end

//  提供额外的信息给服务器进行验证
@interface NSURLProtectionSpace(NSClientCertificateSpace)

//  区分名字
@property (nullable, readonly, copy) NSArray<NSData *> *distinguishedNames API_AVAILABLE(macos(10.6), ios(3.0), watchos(2.0), tvos(9.0));

@end

//  保护空间
@interface NSURLProtectionSpace(NSServerTrustValidationSpace)

//  服务器信任
@property (nullable, readonly) SecTrustRef serverTrust API_AVAILABLE(macos(10.6), ios(3.0), watchos(2.0), tvos(9.0));

@end

NS_ASSUME_NONNULL_END
