//
//  XNFourthViewController.m
//  TestVC
//
//  Created by xn on 2021/8/27.
//

#import "XNFourthViewController.h"

@interface XNFourthViewController ()<UIScrollViewDelegate>

@property (strong,nonatomic)UIScrollView *scrollView;

@property (strong,nonatomic)UIImageView *imageView;

@end

@implementation XNFourthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.scrollView = [UIScrollView new];
    self.imageView = [UIImageView new];
    
    self.scrollView.frame = CGRectMake(100.f, 100.f, 200.f, 200.f);
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    self.imageView.center = CGPointMake(self.scrollView.bounds.size.width/2.f, self.scrollView.bounds.size.height/2.f);
    self.imageView.frame = CGRectMake(self.imageView.center.x -self.scrollView.bounds.size.width/2.f,self.imageView.center.y - self.scrollView.bounds.size.height/2.f, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    self.scrollView.contentSize = self.imageView.bounds.size;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor redColor];
    UIImage *image  = [UIImage imageNamed:@"Image.png"];
    self.imageView.image = image;
    self.scrollView.zoomScale = 1;
    self.scrollView.maximumZoomScale = 5;
    self.scrollView.minimumZoomScale = 0.3;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.bounces = YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

// 只要图片在放大/缩小的过程中都会一直调用

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidZoom");
}

// 开始缩放的时候调用
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    NSLog(@"scrollViewWillBeginZooming");
}
@end
