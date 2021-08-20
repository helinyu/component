//
//  ImageIOViewController.m
//  TestVC
//
//  Created by xn on 2021/8/20.
//

#import "ImageIOViewController.h"

#import <ImageIO/ImageIOBase.h>
#import <ImageIO/CGImageSource.h> // CGImageSourceRef 对象的key ， 以及有关方法
#import <ImageIO/CGImageDestination.h> // 图片的输出对象
#import <ImageIO/CGImageProperties.h> // 图片的有关属性
#import <ImageIO/CGImageMetadata.h> // 图片元数据
#import <ImageIO/CGImageAnimation.h> // 图片动画，动画图片的有关属性


#import <ImageIO/ImageIO.h>
#import <Accelerate/Accelerate.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreImage/CoreImage.h>
#import <ImageCaptureCore/ImageCaptureCore.h>


@interface ImageIOViewController ()

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation ImageIOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test1];
}

- (void)test1 {
    
}

- (void)test0 {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imgView = [UIImageView new];
    [self.view addSubview:self.imgView];
    self.imgView.frame = self.view.bounds;
    
    UIImage *sourceImage = [UIImage imageNamed:@"Flowers_2.png"];
    UIImage *sourceHistoramImage= [UIImage imageNamed:@"Rainbow_1.png"];
    self.imgView.image = [self histogramSpecification:sourceImage histogramSourceImage:sourceHistoramImage];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
}

- (UIImage *)histogramSpecification:(UIImage *)sourceImage histogramSourceImage:(UIImage *)histogramSourceImage {
    
//     vImageBuffer_InitWithCGImage(nil, nil, nil, nil, nil);
    vImage_CGImageFormat format = {
        .bitsPerComponent =  8,
        .bitsPerPixel =  32,
        .colorSpace = CGColorSpaceCreateDeviceRGB(),
        .bitmapInfo = 4,
        .renderingIntent =0
    };
    
    CGImageRef sourceCGImage = sourceImage.CGImage;
    vImage_Buffer buffer = {
      
        
    };
    
    return nil;
}

@end
