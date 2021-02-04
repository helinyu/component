
@interface UIImage (GIF)

/**
 *  Creates an animated UIImage from an NSData.
 *  For static GIF, will create an UIImage with `images` array set to nil. For animated GIF, will create an UIImage with valid `images` array.
 */
+ (UIImage *)sd_animatedGIFWithData:(NSData *)data;
- (BOOL)isGIF;  //可以判断是不是gif图片

@end


//  显示的过程就是解码的过程， 这个过程就是解码的过程
@implementation UIImage (GIF)

+ (UIImage *)sd_animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    return [[SDWebImageGIFCoder sharedCoder] decodedImageWithData:data];
}

- (BOOL)isGIF {
    return (self.images != nil);
}

@end