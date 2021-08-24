//
//  XNThirdViewController.m
//  TestVC
//
//  Created by xn on 2021/8/23.
//

#import "XNThirdViewController.h"
#import "XNPerson.h"
//#import "NSTimer+Extra.h"
#import "NSTimer+YYAdd.h"
#import "HWWeakTimer.h"
#import "YYWeakProxy.h"
#import <Shimmer/FBShimmering.h>
#import <Shimmer/FBShimmeringView.h>

@interface XNThirdViewController ()<UITextViewDelegate>

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) UITextView *tv;

@property (nonatomic, assign) NSTimeInterval lastTime;

@end

@implementation XNThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//
//    self.view.backgroundColor = [UIColor redColor];
//
//    UITextView *tv = [UITextView new];
//    [self.view addSubview:tv];
//    tv.backgroundColor = [UIColor whiteColor];
//    tv.frame = CGRectMake(100.f, 100.f, 100.f, 100.f);
//    tv.delegate = self;
//    self.tv = tv;
//
//    [self startPolling];
    [self testShimmering];

}

- (void)testShimmering {
   CGFloat width = CGRectGetWidth(self.view.bounds);
   CGRect frame = CGRectMake(0, 100, width, 30);
   UILabel *headlinelabel      = [[UILabel alloc]initWithFrame:frame];
   headlinelabel.font = [UIFont systemFontOfSize:20.f];
   headlinelabel.textAlignment = NSTextAlignmentCenter;
   headlinelabel.textColor     = [UIColor cyanColor];
   headlinelabel.text          = @"闪亮文字";
   [headlinelabel sizeToFit];
   [self.view addSubview:headlinelabel];
     
   FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:frame];
   shimmeringView.shimmering                  = YES;
   shimmeringView.shimmeringBeginFadeDuration = 1.f;
   shimmeringView.shimmeringOpacity           = 0.3f;
   shimmeringView.shimmeringAnimationOpacity  = 1.f;
   [self.view addSubview:shimmeringView];
     
   shimmeringView.contentView = headlinelabel;
}


- (void)startPolling {
    self.displayLink = [CADisplayLink displayLinkWithTarget:[YYWeakProxy proxyWithTarget:self] selector:@selector(onDisplayLink:)];
    self.displayLink.frameInterval = 2;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onScheduled:) userInfo:nil repeats:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
 
}
- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"lt ");
}


- (void)onDisplayLink:(CADisplayLink *)link {
    NSLog(@"lt link duration:%f, timestamp:%f, frameInteval :%ld",link.duration, link.timestamp, (long)link.frameInterval);
    NSTimeInterval addTime = self.displayLink.timestamp - self.lastTime;
    self.lastTime = self.displayLink.timestamp;
    NSLog(@"lt begin addtim e;%f",addTime);
}

- (void)onScheduled:(NSTimer *)timer {
    NSLog(@"lt do some thing2222");
}

- (void)doSomething {
    NSLog(@"lt do some thing1111");
}

- (void)dealloc {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
