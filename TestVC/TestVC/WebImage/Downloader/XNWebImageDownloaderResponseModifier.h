//
//  XNWebImageDownloaderResponseModifier.h
//  TestVC
//
//  Created by xn on 2021/12/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSURLResponse * _Nullable (^XNWebImageDownloaderResponseModifierBlock)(NSURLResponse * _Nonnull response);

@protocol XNWebImageDownloaderResponseModifier <NSObject>

// 检查MIME-Type 来设置内容 mock 感觉这个是可以进行测试的作用
- (nullable NSURLResponse *)modifiedResponseWithResponse:(nonnull NSURLResponse *)response;

@end

@interface XNWebImageDownloaderResponseModifier : NSObject <XNWebImageDownloaderResponseModifier>

// 初始化
- (nonnull instancetype)initWithBlock:(XNWebImageDownloaderResponseModifierBlock)block;
+ (nonnull instancetype)responseWithModifierWithBlock:(nonnull XNWebImageDownloaderResponseModifierBlock)block;

@end


@interface XNWebImageDownloaderResponseModifier (Conveniences)

// status code设置
- (nonnull instancetype)initWithStatusCode:(NSInteger)statusCode;
- (nonnull instancetype)initWithVersion:(nullable NSString *)version;
- (nonnull instancetype)initWithHeaders:(nullable NSDictionary<NSString *, NSString *> *)headers;
- (nonnull instancetype)initWithStatusCode:(NSInteger)statusCode version:(nullable NSString *)version headers:(nullable NSDictionary<NSString *, NSString *> *)headers;

@end

NS_ASSUME_NONNULL_END
