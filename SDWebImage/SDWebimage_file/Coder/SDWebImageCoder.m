
#import <Foundation/Foundation.h>
#import "SDWebImageCompat.h"
#import "NSData+ImageContentType.h"

/**
 A Boolean value indicating whether to scale down large images during decompressing. (NSNumber)
 */
FOUNDATION_EXPORT NSString * _Nonnull const SDWebImageCoderScaleDownLargeImagesKey;

/**
 Return the shared device-dependent RGB color space created with CGColorSpaceCreateDeviceRGB.

 @return The device-dependent RGB color space
 */
CG_EXTERN CGColorSpaceRef _Nonnull SDCGColorSpaceGetDeviceRGB(void);

/**
 Check whether CGImageRef contains alpha channel.

 @param imageRef The CGImageRef
 @return Return YES if CGImageRef contains alpha channel, otherwise return NO
 */
CG_EXTERN BOOL SDCGImageRefContainsAlpha(_Nullable CGImageRef imageRef);


//  基本的图片解码
@protocol SDWebImageCoder <NSObject>

@required
#pragma mark - Decoding

- (BOOL)canDecodeFromData:(nullable NSData *)data;

//  解码图像数据
- (nullable UIImage *)decodedImageWithData:(nullable NSData *)data;

//  解码解压缩的过程
- (nullable UIImage *)decompressedImageWithImage:(nullable UIImage *)image
                                            data:(NSData * _Nullable * _Nonnull)data
                                         options:(nullable NSDictionary<NSString*, NSObject*>*)optionsDict;

#pragma mark - Encoding

//  编码的内容
- (BOOL)canEncodeToFormat:(SDImageFormat)format;
- (nullable NSData *)encodedDataWithImage:(nullable UIImage *)image format:(SDImageFormat)format;

@end


// 有进度的解码器
@protocol SDWebImageProgressiveCoder <SDWebImageCoder>

@required

- (BOOL)canIncrementallyDecodeFromData:(nullable NSData *)data;
- (nullable UIImage *)incrementallyDecodedImageWithData:(nullable NSData *)data finished:(BOOL)finished;

@end
