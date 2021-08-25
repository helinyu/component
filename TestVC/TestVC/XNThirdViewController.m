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
{
    NSThread *_thread;
    BOOL _stop;
}

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) UITextView *tv;

@property (nonatomic, assign) NSTimeInterval lastTime;

@end

@implementation XNThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor redColor];
//
//    UITextView *tv = [UITextView new];
//    [self.view addSubview:tv];
//    tv.backgroundColor = [UIColor whiteColor];
//    tv.frame = CGRectMake(100.f, 100.f, 100.f, 100.f);
//    tv.delegate = self;
//    self.tv = tv;
//
//    [self startPolling];
//    [self testShimmering];
    
//    [self testRunloop];
    [self testRunloopAlive];
}

- (void)testRunloopAlive {
//    NSThread *th = [[NSThread alloc] initWithTarget:self selector:@selector(testThread) object:nil];
    NSRunLoop *main =  [NSRunLoop mainRunLoop];
    NSRunLoop *current = [NSRunLoop currentRunLoop];
    __block NSRunLoop *main1;
    __block NSRunLoop *current1;
    dispatch_async(dispatch_queue_create("skinReadImageQueue", DISPATCH_QUEUE_CONCURRENT), ^{
        self->_thread = [NSThread currentThread];
        NSLog(@"lt - %p, %p , %p , %p",main,current,main1, current1);
        NSLog(@"lt - %p, %p , %p , %p",main,current,main1, current1);
        [self testThread];
    });

}

// 上一次的执行，启动下一次的runloop
- (void)testThread{
    NSLog(@"test thread");

// 注释与否来触发触摸时间，这个对象是否还会在该线程中调用
    // 向runloop里面添加事件source/timer/observer
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
    while (!_stop) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    
}
- (void)testAnother{
    NSLog(@"test another");
    NSRunLoop * main1 = [NSRunLoop mainRunLoop];
    NSRunLoop * current1 = [NSRunLoop currentRunLoop];
    NSLog(@"lt - %p , %p",main1, current1);
    NSLog(@"lt - %p , %p",main1, current1);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self performSelector:@selector(testAnother) onThread:_thread withObject:nil waitUntilDone:NO];
}

// 销毁线程的runloop
- (void)stop{
//     当前的线程stop掉
    _stop = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
}
- (void)stopRunloop{
    [self performSelector:@selector(stop) onThread:_thread withObject:nil waitUntilDone:NO];
}


- (void)testRunloop {
    
    NSRunLoop *main =  [NSRunLoop mainRunLoop];
    NSRunLoop *current = [NSRunLoop currentRunLoop];
    __block NSRunLoop *main1;
    __block NSRunLoop *current1;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        main1 = [NSRunLoop mainRunLoop];
        current1 = [NSRunLoop currentRunLoop];
    });
    NSLog(@"lt - %p, %p , %p , %p",main,current,main1, current1);
    NSLog(@"lt - %p, %p , %p , %p",main,current,main1, current1);
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
