//
//  XNWebImageDownloaderDecryptor.m
//  TestVC
//
//  Created by xn on 2021/12/23.
//

#import "XNWebImageDownloaderDecryptor.h"

@interface XNWebImageDownloaderDecryptor ()

@property (nonatomic, copy, nonnull) XNWebImageDownloaderDecryptorBlock block;

@end

@implementation XNWebImageDownloaderDecryptor

- (instancetype)initWithBlock:(XNWebImageDownloaderDecryptorBlock)block {
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

+ (instancetype)decryptorWithBlock:(XNWebImageDownloaderDecryptorBlock)block {
    XNWebImageDownloaderDecryptor *decryptor = [[XNWebImageDownloaderDecryptor alloc] initWithBlock:block];
    return decryptor;
}

- (nullable NSData *)decrytedDataWithData:(nonnull NSData *)data response:(nullable NSURLResponse *)response {
    return self.block? self.block(data,response):nil;
}

@end

@implementation XNWebImageDownloaderDecryptor (Conveniences)

+ (XNWebImageDownloaderDecryptor *)base64Decryptor {
    static XNWebImageDownloaderDecryptor *decryptor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        decryptor = [XNWebImageDownloaderDecryptor decryptorWithBlock:^NSData * _Nullable(NSData * _Nonnull data, NSURLResponse * _Nullable response) {
            NSData *modifiedData = [[NSData alloc] initWithBase64EncodedData:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
            return modifiedData;
        }];
    });
    return decryptor;
}

@end
