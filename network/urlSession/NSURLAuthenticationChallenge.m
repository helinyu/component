// 授权的类 ， 看看这个内容要怎么进行处理

/*	
    NSURLAuthenticationChallenge.h
    Copyright (c) 2003-2019, Apple Inc. All rights reserved.    
    
    Public header file.
*/

#import <Foundation/NSObject.h>

@class NSURLAuthenticationChallenge;
@class NSURLCredential;
@class NSURLProtectionSpace;
@class NSURLResponse;
@class NSError;

//  https://www.cnblogs.com/code-life/p/7806824.html
//  几个重要的概念理解


NS_ASSUME_NONNULL_BEGIN

// credential： 验证，可能是certificate的某一项的认证能力,
// certificate：证书

// 授权challenge的sender
// 接口表示表示的是一个authentication challenge 的发送者
//  有方法提供一个credential（证件），基础如果没有credential的时候，获取结构是失败、取消一个challenge ，执行系统的默认行为， 或者拒绝当前的保护空间的挑战。

API_AVAILABLE(macos(10.2), ios(2.0), watchos(2.0), tvos(9.0))
@protocol NSURLAuthenticationChallengeSender <NSObject> // 认证质询发送者

- (void)useCredential:(NSURLCredential *)credential forAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
- (void)continueWithoutCredentialForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
- (void)cancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;

@optional

- (void)performDefaultHandlingForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
//  执行默认处理，对于challenge

- (void)rejectProtectionSpaceAndContinueWithChallenge:(NSURLAuthenticationChallenge *)challenge;
// 拒绝保护空间和challenge继续

@end

@class NSURLAuthenticationChallengeInternal;

/*!
    @class NSURLAuthenticationChallenge 认证质询
    // 表示一个authentication challenge ， 提供了所有关于challenge的信息，和有一个方法表示当它完成
*/

API_AVAILABLE(macos(10.2), ios(2.0), watchos(2.0), tvos(9.0))
@interface NSURLAuthenticationChallenge : NSObject <NSSecureCoding> // 授权质询
{
@private
    NSURLAuthenticationChallengeInternal *_internal;
}

/*!
    @param space 保护空间
    @param credential NSURLCredential 验证
    @param previousFailureCount 失败的次数
    @param response 失败的响应
    @param error 错误原因
*/
//  初始化一个验证质询
- (instancetype)initWithProtectionSpace:(NSURLProtectionSpace *)space proposedCredential:(nullable NSURLCredential *)credential previousFailureCount:(NSInteger)previousFailureCount failureResponse:(nullable NSURLResponse *)response error:(nullable NSError *)error sender:(id<NSURLAuthenticationChallengeSender>)sender;

//  授权执行
// 发送者
- (instancetype)initWithAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge sender:(id<NSURLAuthenticationChallengeSender>)sender;

//  保护域
@property (readonly, copy) NSURLProtectionSpace *protectionSpace;

//  目的验证
@property (nullable, readonly, copy) NSURLCredential *proposedCredential;

//  过去失败的次数
@property (readonly) NSInteger previousFailureCount;

//  失败的响应
@property (nullable, readonly, copy) NSURLResponse *failureResponse;

//  授权错误信息
@property (nullable, readonly, copy) NSError *error;

//  授权质询的发送者
@property (nullable, readonly, retain) id<NSURLAuthenticationChallengeSender> sender;

@end

NS_ASSUME_NONNULL_END
