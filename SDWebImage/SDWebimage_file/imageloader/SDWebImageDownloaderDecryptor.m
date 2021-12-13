// 加解密的处理
typedef NSData * _Nullable (^SDWebImageDownloaderDecryptorBlock)(NSData * _Nonnull data, NSURLResponse * _Nullable response);

/**
This is the protocol for downloader decryptor. Which decrypt the original encrypted data before decoding. Note progressive decoding is not compatible for decryptor.
We can use a block to specify the downloader decryptor. But Using protocol can make this extensible, and allow Swift user to use it easily instead of using `@convention(block)` to store a block into context options.
*/
//  解密器
@protocol SDWebImageDownloaderDecryptor <NSObject>

/// Decrypt the original download data and return a new data. You can use this to decrypt the data using your preferred algorithm.
/// @param data The original download data
/// @param response The URL response for data. If you modify the original URL response via response modifier, the modified version will be here. This arg is nullable.
/// @note If nil is returned, the image download will be marked as failed with error `SDWebImageErrorBadImageData`
- (nullable NSData *)decryptedDataWithData:(nonnull NSData *)data response:(nullable NSURLResponse *)response;

@end

@interface SDWebImageDownloaderDecryptor : NSObject <SDWebImageDownloaderDecryptor>

//  类方法和实例方法进行创建了一个解码器
- (nonnull instancetype)initWithBlock:(nonnull SDWebImageDownloaderDecryptorBlock)block;
+ (nonnull instancetype)decryptorWithBlock:(nonnull SDWebImageDownloaderDecryptorBlock)block;

@end

//  遍历的方法
@interface SDWebImageDownloaderDecryptor (Conveniences)

//  基本的64的编码
@property (class, readonly, nonnull) SDWebImageDownloaderDecryptor *base64Decryptor;

@end



@interface SDWebImageDownloaderDecryptor ()

@property (nonatomic, copy, nonnull) SDWebImageDownloaderDecryptorBlock block;

@end

@implementation SDWebImageDownloaderDecryptor

- (instancetype)initWithBlock:(SDWebImageDownloaderDecryptorBlock)block {
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

+ (instancetype)decryptorWithBlock:(SDWebImageDownloaderDecryptorBlock)block {
    SDWebImageDownloaderDecryptor *decryptor = [[SDWebImageDownloaderDecryptor alloc] initWithBlock:block];
    return decryptor;
}

- (nullable NSData *)decryptedDataWithData:(nonnull NSData *)data response:(nullable NSURLResponse *)response {
    if (!self.block) {
        return nil;
    }
    return self.block(data, response);
}

@end

@implementation SDWebImageDownloaderDecryptor (Conveniences)

//  这里做了一个最为基本的base64的编码， 因为和网络有关系
+ (SDWebImageDownloaderDecryptor *)base64Decryptor {
    static SDWebImageDownloaderDecryptor *decryptor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        decryptor = [SDWebImageDownloaderDecryptor decryptorWithBlock:^NSData * _Nullable(NSData * _Nonnull data, NSURLResponse * _Nullable response) {
            NSData *modifiedData = [[NSData alloc] initWithBase64EncodedData:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
            return modifiedData;
        }];
    });
    return decryptor;
}

@end
