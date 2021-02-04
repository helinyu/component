//  图片在内存中的缓存

@interface UIImage (MemoryCacheCost)

/**
 The memory cache cost for specify image used by image cache. The cost function is the pixles count held in memory.
 If you set some associated object to `UIImage`, you can set the custom value to indicate the memory cost.
 
 For `UIImage`, this method return the single frame pixles count when `image.images` is nil for static image. Retuen full frame pixels count when `image.images` is not nil for animated image.
 For `NSImage`, this method return the single frame pixels count because `NSImage` does not store all frames in memory.
 @note Note that because of the limitations of categories this property can get out of sync if you create another instance with CGImage or other methods.
 */
@property (assign, nonatomic) NSUInteger sd_memoryCost;

@end



#import "UIImage+MemoryCacheCost.h"
#import "objc/runtime.h"

FOUNDATION_STATIC_INLINE NSUInteger SDMemoryCacheCostForImage(UIImage *image) {
#if SD_MAC
    return image.size.height * image.size.width;
#elif SD_UIKIT || SD_WATCH
    NSUInteger imageSize = image.size.height * image.size.width * image.scale * image.scale;
    return image.images ? (imageSize * image.images.count) : imageSize;
#endif
}

@implementation UIImage (MemoryCacheCost)

- (NSUInteger)sd_memoryCost {
    NSNumber *value = objc_getAssociatedObject(self, @selector(sd_memoryCost));
    NSUInteger memoryCost;
    if (value != nil) {
        memoryCost = [value unsignedIntegerValue];
    } else {
        memoryCost = SDMemoryCacheCostForImage(self);
    }
    return memoryCost;
}

- (void)setSd_memoryCost:(NSUInteger)sd_memoryCost {
    objc_setAssociatedObject(self, @selector(sd_memoryCost), @(sd_memoryCost), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

