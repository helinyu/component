/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "SDWebImageCompat.h"
#import "NSData+ImageContentType.h"

/**
 A Boolean value indicating whether to scale down large images during decompressing. (NSNumber)
 */
// 是否下载Large scale 图片
FOUNDATION_EXPORT NSString * _Nonnull const SDWebImageCoderScaleDownLargeImagesKey;

/**
 Return the shared device-dependent RGB color space created with CGColorSpaceCreateDeviceRGB.

 @return The device-dependent RGB color space
 */
// 颜色额空间
CG_EXTERN CGColorSpaceRef _Nonnull SDCGColorSpaceGetDeviceRGB(void);

/**
 Check whether CGImageRef contains alpha channel.

 @param imageRef The CGImageRef
 @return Return YES if CGImageRef contains alpha channel, otherwise return NO
 */
// 判断图片是否有alpha通道
CG_EXTERN BOOL SDCGImageRefContainsAlpha(_Nullable CGImageRef imageRef);


/**
 This is the image coder protocol to provide custom image decoding/encoding.
 These methods are all required to implement.
 @note Pay attention that these methods are not called from main queue.
 */
@protocol SDWebImageCoder <NSObject>

@required
#pragma mark - Decoding
/**
 Returns YES if this coder can decode some data. Otherwise, the data should be passed to another coder.
 
 @param data The image data so we can look at it
 @return YES if this coder can decode the data, NO otherwise
 */
// 是否可以解码
- (BOOL)canDecodeFromData:(nullable NSData *)data;

/**
 Decode the image data to image.

 @param data The image data to be decoded
 @return The decoded image from data
 */
// 解码数据
- (nullable UIImage *)decodedImageWithData:(nullable NSData *)data;

/**
 Decompress the image with original image and image data.

 @param image The original image to be decompressed
 @param data The pointer to original image data. The pointer itself is nonnull but image data can be null. This data will set to cache if needed. If you do not need to modify data at the sametime, ignore this param.
 @param optionsDict A dictionary containing any decompressing options. Pass {SDWebImageCoderScaleDownLargeImagesKey: @(YES)} to scale down large images
 @return The decompressed image
 */
// 解压缩 ， 什么是解码？ 什么是解压缩？ 什么是编码？ 这个为啥子不是对应的？
- (nullable UIImage *)decompressedImageWithImage:(nullable UIImage *)image
                                            data:(NSData * _Nullable * _Nonnull)data
                                         options:(nullable NSDictionary<NSString*, NSObject*>*)optionsDict;

#pragma mark - Encoding

/**
 Returns YES if this coder can encode some image. Otherwise, it should be passed to another coder.
 
 @param format The image format
 @return YES if this coder can encode the image, NO otherwise
 */
// 是否可以编码指定格式
- (BOOL)canEncodeToFormat:(SDImageFormat)format;

/**
 Encode the image to image data.

 @param image The image to be encoded
 @param format The image format to encode, you should note `SDImageFormatUndefined` format is also  possible
 @return The encoded image data
 */
// 编码图片指定的数据格式
- (nullable NSData *)encodedDataWithImage:(nullable UIImage *)image format:(SDImageFormat)format;

@end


/**
 This is the image coder protocol to provide custom progressive image decoding.
 These methods are all required to implement.
 @note Pay attention that these methods are not called from main queue.
 */
// 增长式解码
@protocol SDWebImageProgressiveCoder <SDWebImageCoder>

@required
/**
 Returns YES if this coder can incremental decode some data. Otherwise, it should be passed to another coder.
 
 @param data The image data so we can look at it 我们能够查询的图片数据
 @return YES if this coder can decode the data, NO otherwise  YES表示能够解码
 */
// 能够增长从data中解码数据
- (BOOL)canIncrementallyDecodeFromData:(nullable NSData *)data;

/**
 Incremental decode the image data to image.
 
 @param data The image data has been downloaded so far
 @param finished Whether the download has finished
 @warning because incremental decoding need to keep the decoded context, we will alloc a new instance with the same class for each download operation to avoid conflicts
 @return The decoded image from data
 */
// 是否能够解码数据
- (nullable UIImage *)incrementallyDecodedImageWithData:(nullable NSData *)data finished:(BOOL)finished;

@end
