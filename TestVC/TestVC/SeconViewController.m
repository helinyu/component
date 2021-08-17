//
//  SeconViewController.m
//  TestVC
//
//  Created by xn on 2021/8/17.
//

#import "SeconViewController.h"
#import "FLAnimatedImageView.h"
//#import "UIView+WebCache.h"
#import <SDWebImage/UIView+WebCache.h>
#import <SDWebImage/FLAnimatedImageView+WebCache.h>
#import "SeconViewController.h"
#import <YYImage/YYImage.h>
#import <YYWebImage.h>

@interface SeconViewController ()

@property (nonatomic, strong) FLAnimatedImageView *imgview_fl;
@property (nonatomic, strong) YYAnimatedImageView *imgview_yy;
@property (nonatomic, strong) UIImageView *imgView_sy;

@end

@implementation SeconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor blueColor];
    
//    [self testYY];
//    [self testFl];
    [self testsy];
}

- (void)testsy {
//    animationImages
    
    UIImage *img = [UIImage new];
    
    
    _imgView_sy = [UIImageView new];
    [self.view addSubview:_imgView_sy];
    _imgView_sy.frame = self.view.bounds;
    self.imgView_sy.contentMode = UIViewContentModeScaleAspectFit;
    NSURL *imgUrl = [NSURL URLWithString:@"https://cloud.githubusercontent.com/assets/1567433/10417835/1c97e436-7052-11e5-8fb5-69373072a5a0.gif"];
    [[[NSURLSession sharedSession] dataTaskWithURL:imgUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            FLAnimatedImage *aniImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:data];
            
            NSMutableArray *imgs = [NSMutableArray new];
            for (NSInteger index =0; index <aniImage.frameCount; index++) {
                [imgs addObject:[aniImage imageAtIndex:index]];
            }
            self->_imgView_sy.animationImages = imgs;
            [self->_imgView_sy startAnimating];
            
            self.imgView_sy.image = imgs.firstObject;
        });
    }] resume];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(0.f, 0.f, 100.f, 60.f);
    btn.backgroundColor = [UIColor purpleColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onBtn) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)onBtn {
    self.imgView_sy.animating? [self.imgView_sy stopAnimating]:[self.imgView_sy startAnimating];
}

- (void)testYY {
    self.imgview_yy = [YYAnimatedImageView new];
}

- (void)testFl {
    // Do any additional setup after loading the view.
    _imgview_fl = [FLAnimatedImageView new];
    [self.view addSubview:_imgview_fl];
    _imgview_fl.frame = self.view.bounds;
    
    NSURL *imgUrl = [NSURL URLWithString:@"https://cloud.githubusercontent.com/assets/1567433/10417835/1c97e436-7052-11e5-8fb5-69373072a5a0.gif"];
//    NSURL *imgUrl = [NSURL URLWithString:@"https://static.paixin.com/paixin-home/static/img/2t4qgvwrg45wt54q3gfrefgvw45ygfvbwt5y.d9d53b4.png"];
    self.imgview_fl.contentMode = UIViewContentModeScaleAspectFit;
    
    [self loadAnimatedImageWithURL:imgUrl completion:^(FLAnimatedImage *animatedImage) {
        self.imgview_fl.animatedImage = animatedImage;
    }];
//    [self.imgview sd_setImageWithURL:imgUrl placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
////        NSLog(@"");
//    }];
}

- (void)loadAnimatedImageWithURL:(NSURL *const)url completion:(void (^)(FLAnimatedImage *animatedImage))completion
{
    NSString *const filename = url.lastPathComponent;
    NSString *const diskPath = [NSHomeDirectory() stringByAppendingPathComponent:filename];
    
    NSData * __block animatedImageData = [[NSFileManager defaultManager] contentsAtPath:diskPath];
//     应该是可以判断这个数据是不是gif的数据，
    FLAnimatedImage * __block animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:animatedImageData];
    
    if (animatedImage) {
        if (completion) {
            completion(animatedImage);
        }
    } else {
        [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            animatedImageData = data;
            animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:animatedImageData];
            if (animatedImage) {
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(animatedImage);
                    });
                }
                [data writeToFile:diskPath atomically:YES];
            }
        }] resume];
    }
}


@end
