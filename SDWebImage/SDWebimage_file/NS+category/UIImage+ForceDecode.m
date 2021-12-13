//  这个是解码的内容

@interface UIImage (ForceDecode)
+ (nullable UIImage *)decodedImageWithImage:(nullable UIImage *)image;
+ (nullable UIImage *)decodedAndScaledDownImageWithImage:(nullable UIImage *)image;
@end

@implementation UIImage (ForceDecode)

+ (UIImage *)decodedImageWithImage:(UIImage *)image {
    if (!image) {
        return nil;
    }
    NSData *tempData;
    return [[SDWebImageCodersManager sharedInstance] decompressedImageWithImage:image data:&tempData options:@{SDWebImageCoderScaleDownLargeImagesKey: @(NO)}];
}

+ (UIImage *)decodedAndScaledDownImageWithImage:(UIImage *)image {
    if (!image) {
        return nil;
    }
    NSData *tempData;
    return [[SDWebImageCodersManager sharedInstance] decompressedImageWithImage:image data:&tempData options:@{SDWebImageCoderScaleDownLargeImagesKey: @(YES)}];
}

@end


//  解码有解码的管理器
