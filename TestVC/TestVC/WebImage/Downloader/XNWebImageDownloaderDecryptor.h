//
//  XNWebImageDownloaderDecryptor.h
//  TestVC
//
//  Created by xn on 2021/12/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSData * _Nullable (^XNWebImageDownloaderDecryptorBlock)(NSData * _Nonnull data, NSURLResponse * _Nullable response);

@protocol XNWebImageDownloaderDecryptor <NSObject>

/// 解密原始数据
/// data: 原始的数据
/// response: 给data的response
/// 如果返回空，将会是一个失败的请求 SDWebImageErrorBadImageData
- (nullable NSData *)decrytedDataWithData:(nonnull NSData *)data response:(nullable NSURLResponse *)response;

@end

@interface XNWebImageDownloaderDecryptor : NSObject <XNWebImageDownloaderDecryptor>

- (nonnull instancetype)initWithBlock:(nonnull XNWebImageDownloaderDecryptorBlock)block;
+ (nonnull instancetype)decryptorWithBlock:(nonnull XNWebImageDownloaderDecryptorBlock)block;

@end

@interface XNWebImageDownloaderDecryptor (Conveniences)

// base64编码的 图像数据解码器
@property (class, readonly, nonnull) XNWebImageDownloaderDecryptor *base64Decryptor;

@end

NS_ASSUME_NONNULL_END
