// webp 的内功进行解码

@interface UIImage (WebP)

/**
 * Get the current WebP image loop count, the default value is 0.
 * For static WebP image, the value is 0.
 * For animated WebP image, 0 means repeat the animation indefinitely.
 * Note that because of the limitations of categories this property can get out of sync
 * if you create another instance with CGImage or other methods.
 * @return WebP image loop count
 * @deprecated use `sd_imageLoopCount` instead.
 */
- (NSInteger)sd_webpLoopCount __deprecated_msg("Method deprecated. Use `sd_imageLoopCount` in `UIImage+MultiFormat.h`");

+ (nullable UIImage *)sd_imageWithWebPData:(nullable NSData *)data;

@end

#import "UIImage+WebP.h"
#import "SDWebImageWebPCoder.h"
#import "UIImage+MultiFormat.h"

@implementation UIImage (WebP)

- (NSInteger)sd_webpLoopCount {
    return self.sd_imageLoopCount;
}

+ (nullable UIImage *)sd_imageWithWebPData:(nullable NSData *)data {
    if (!data) {
        return nil;
    }
    return [[SDWebImageWebPCoder sharedCoder] decodedImageWithData:data];
}

@end

#endif
