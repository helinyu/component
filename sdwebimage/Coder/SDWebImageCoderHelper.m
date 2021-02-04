//  解码器的帮助类 




#import <Foundation/Foundation.h>
#import "SDWebImageCompat.h"
#import "SDWebImageFrame.h"

@interface SDWebImageCoderHelper : NSObject

//  帧和托片之间的转换
+ (UIImage * _Nullable)animatedImageWithFrames:(NSArray<SDWebImageFrame *> * _Nullable)frames;
+ (NSArray<SDWebImageFrame *> * _Nullable)framesFromAnimatedImage:(UIImage * _Nullable)animatedImage;

#if SD_UIKIT || SD_WATCH

// 图片的方向
+ (UIImageOrientation)imageOrientationFromEXIFOrientation:(NSInteger)exifOrientation;
+ (NSInteger)exifOrientationFromImageOrientation:(UIImageOrientation)imageOrientation;

#endif

@end

