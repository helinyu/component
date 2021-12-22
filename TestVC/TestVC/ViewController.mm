//
//  ViewController.m
//  TestVC
//
//  Created by xn on 2021/7/29.
//

#import "ViewController.h"
#import <MMKV/MMKV.h>
#import "SecondViewController.h"
#import "XNPerson.h"
#import "ImageIOViewController.h"
#import <libkern/OSAtomic.h>
#import "XNLockModel.h"

#import "XNThirdViewController.h"
#import "DecoratorViewController.h"
#import "XNFourthViewController.h"

#import <objc/NSObjCRuntime.h>
#import <objc/runtime.h>

#import "VisitorHeader.h"
#import "MyWorkerClass.h"
#include <stdio.h>
#import "XNFiveViewViewController.h"

#import <SDWebImage/SDImageCache.h>
#import <ImageIO/ImageIO.h>

@interface ViewController ()<NSPortDelegate>
{
    id _object;
}

@property (nonatomic, strong) NSPointerArray *pointArr;
@property (nonatomic, strong) NSMutableArray *arr;

@property (nonatomic, weak) NSString *text;

@property (nonatomic, weak) XNPerson *person;

@property (nonatomic, weak) id obj;

@end


CGImageRef MyCreateCGImageFromFile(NSString *path) {
    // get the URL for the pathName passed to the function
    NSURL *url = [NSURL URLWithString:path];
    CGImageRef myImage = NULL;
    CGImageSourceRef myImageSource;
    CFDictionaryRef myOptions = NULL;
    CFStringRef myKeys[2];
    CFTypeRef myValues[2];
    
    // set up options if you want them .
    // The options here are for caching the image in a decoded form and for using floating-point values if the image format supports them.
    myKeys[0] = kCGImageSourceShouldCache;
    myValues[0] = (CFTypeRef)kCFBooleanTrue;
    myKeys[1] = kCGImageSourceShouldAllowFloat;
    myValues[1] = (CFTypeRef)kCFBooleanTrue;
    
    // create the dictionary
    myOptions = CFDictionaryCreate(NULL, (const void **) myKeys,
                                   (const void **) myValues, 2,
                                   &kCFTypeDictionaryKeyCallBacks,
                                   &kCFTypeDictionaryValueCallBacks);

    // Create an image source from the URL.
    myImageSource = CGImageSourceCreateWithURL((CFURLRef)url, myOptions);
    CFRelease(myOptions);

    // Make sure the image source exists before continuing
    if (myImageSource == NULL){
        fprintf(stderr, "Image source is NULL.");
        return  NULL;
    }

    // Create an image from the first item in the image source.
    myImage = CGImageSourceCreateImageAtIndex(myImageSource, 0, NULL);

    CFRelease(myImageSource);
    // Make sure the image exists before continuing
    if (myImage == NULL){
        fprintf(stderr, "Image not created from image source.");
        return NULL;
    }
    return myImage;
}

// 创建缩略图
CGImageRef MyCreateThumbnailImageFromData (NSData * data, int imageSize)
{
    CGImageRef        myThumbnailImage = NULL;
    CGImageSourceRef  myImageSource;
    CFDictionaryRef   myOptions = NULL;
    CFStringRef       myKeys[3];
    CFTypeRef         myValues[3];
    CFNumberRef       thumbnailSize;
 
   // Create an image source from NSData; no options.
   myImageSource = CGImageSourceCreateWithData((CFDataRef)data,
                                               NULL);
   // Make sure the image source exists before continuing.
   if (myImageSource == NULL){
        fprintf(stderr, "Image source is NULL.");
        return  NULL;
   }
 
   // Package the integer as a  CFNumber object. Using CFTypes allows you
   // to more easily create the options dictionary later.
   thumbnailSize = CFNumberCreate(NULL, kCFNumberIntType, &imageSize);
 
   // Set up the thumbnail options.
   myKeys[0] = kCGImageSourceCreateThumbnailWithTransform;
   myValues[0] = (CFTypeRef)kCFBooleanTrue;
   myKeys[1] = kCGImageSourceCreateThumbnailFromImageIfAbsent;
   myValues[1] = (CFTypeRef)kCFBooleanTrue;
   myKeys[2] = kCGImageSourceThumbnailMaxPixelSize;
   myValues[2] = (CFTypeRef)thumbnailSize;
 
   myOptions = CFDictionaryCreate(NULL, (const void **) myKeys,
                   (const void **) myValues, 2,
                   &kCFTypeDictionaryKeyCallBacks,
                   & kCFTypeDictionaryValueCallBacks);
 
  // Create the thumbnail image using the specified options.
  myThumbnailImage = CGImageSourceCreateThumbnailAtIndex(myImageSource,
                                          0,
                                          myOptions);
  // Release the options dictionary and the image source
  // when you no longer need them.
  CFRelease(thumbnailSize);
  CFRelease(myOptions);
  CFRelease(myImageSource);
 
   // Make sure the thumbnail image exists before continuing.
   if (myThumbnailImage == NULL){
         fprintf(stderr, "Thumbnail image not created from image source.");
         return NULL;
   }
 
   return myThumbnailImage;
}


@implementation ViewController

- (void)setup {
    _object = [NSObject new];
}

- (void)onTap2 {
    ImageIOViewController *vc = [ImageIOViewController new];
    [self presentViewController:vc  animated:YES completion:nil];
    
    
    //  OSSpinLock自旋锁的初始化
    OSSpinLock _lock = OS_SPINLOCK_INIT;

    //  锁定
    OSSpinLockLock(&_lock);

    // 解锁
    OSSpinLockUnlock(&_lock);

    
    
}


- (void)onSel {
    
}

- (void)onMutiThread:(NSNotification *)noti {
    NSLog(@"lt - muti thread : %@",noti);
}

- (void)onSingleThread:(NSNotification *)noti {
    NSLog(@"lt - single thread :%@",noti);
}

- (void)onWillExitThread:(NSNotification *)noti {
    NSLog(@"lt - onWillExitThread :%@",noti);
}

- (NSString *)stringValue {
    NSString *str = [[NSString alloc] initWithFormat:@"nihaoya :%d",1];
    NSString *str1 = [[NSString alloc] initWithFormat:@"nihaoya :%d",2];
    return str;
}

#define kMsg1 100
#define kMag2 101

//- (void)handlePortMessage:(void *)message;
- (void)handlePortMessage:(NSMessagePort *)message
{
    NSLog(@"message :%@",message);
    NSUInteger msgId = [[message valueForKeyPath:@"msgid"] integerValue];
    NSMachPort *localPort = [message valueForKeyPath:@"localPort"];
    NSMachPort *remotePort = [message valueForKeyPath:@"remotePort"];
    NSMutableArray *componts = [message valueForKey:@"components"];
    for (NSData *data in componts) {
        NSLog(@"data is %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }

    if (msgId == kMsg1) {
        [remotePort sendBeforeDate:[NSDate date] msgid:kMag2 components:nil from:localPort reserved:0];
    }
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"lt - opertaion");
        }];
        [operation start];
        return;
    }
    
    {
        NSObject *obj = [NSObject new];
        NSPointerArray *pointerArray = [NSPointerArray weakObjectsPointerArray];
        [pointerArray addPointer:(__bridge void *)obj];
        [pointerArray addPointer:(__bridge void *)[NSNull null]];
        NSLog(@"lt - count ;%d",pointerArray.count);
        obj = nil;
        NSLog(@"lt - count ;%d",pointerArray.count);
        [pointerArray addPointer:NULL];
        [pointerArray compact];
        NSLog(@"lt - count ;%d",pointerArray.count);
        NSLog(@"lt - count ;%d",pointerArray.count);
        Nil;

        return;
    }
    
    {
        UIImageView *imgView = [UIImageView new];
        imgView.frame = CGRectMake(100.f, 100.f, 100.f, 100.f);
        imgView.backgroundColor = [UIColor redColor];
        
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"icon_main_ranking.png"]];
        UIImage *img1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"icon_main_ranking@3x.png"]];
        UIImage *img2 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"icon_main_ranking@2x.png"]];
        CGFloat scale = [UIScreen mainScreen].scale;
        CGFloat nativeScale  = [UIScreen mainScreen].nativeScale;
        NSLog(@"lt -  ");
        return;
    }
    
    {
        SDImageCache *cache = [SDImageCache sharedImageCache];
        UIImage *image = [UIImage imageNamed:@"Snip20211214_8.png"];
        [cache storeImage:image forKey:@"hahha" completion:^{
            NSLog(@"");
        }];
        return;
    
    }
    
    {
        NSCache *cache = [[NSCache alloc] init];
        cache.countLimit = 3;
        [cache setObject:@"nihao" forKey:@"nihao"];
        [cache setObject:@"nihao" forKey:@"niha1"];
        [cache setObject:@"nihao" forKey:nil];
        
        NSLog(@"lt cache ");
        
        NSMutableDictionary *dict = [NSMutableDictionary new];
        cache.countLimit = 3;
        [dict setObject:@"nihao" forKey:@"nihao"];
        [dict setObject:@"nihao" forKey:@"niha1"];
        
        [dict setObject:nil forKey:@"niha1"];
        NSLog(@"lt dict ");

        return;
    }
    
    {
        XNFiveViewViewController *vc = [XNFiveViewViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    {
        NSPort *myPort = [NSMachPort port];
        myPort.delegate = self;
        [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
        
        NSLog(@"-- myport :%@",myPort);
        MyWorkerClass *work = [MyWorkerClass new];
        [NSThread detachNewThreadSelector:@selector(launchThreadWithPort:) toTarget:work withObject:myPort];
        
        NSObject *obj = [ NSObject new];
        [obj performSelector:@selector(onTap) withObject:nil afterDelay:2.f];
        [self performSelectorOnMainThread:@selector(onTap) withObject:nil waitUntilDone:YES];
        
        return;
    }
    
    
    {
        NSPort *port = [NSPort port];
        NSPort *matchPort = [NSMachPort port];
        NSLog(@"lt - port :%@",port);
        return;
    }
    
    {
       __block XNPerson *p = [XNPerson new];
        void (^block)(void);
        int a = 2;
        if (a > 1){
            block = ^(void) {
                NSLog(@"aae");
                NSLog(@"lt - person :%@",p);
                p.name = @"hel;inyu";
            };
        }
        else {
            block = ^(void) {
                NSLog(@"bbb");
            };
        }
        block();
        return;
    }
    
    
    {
        NSString *string = [self stringValue];
        NSLog(@"lt - str:%@",string);
        return;
    }
    
    {
        Man *man = [Man new];
        Woman *woman = [Woman new];
        Success *suc = [Success new];
        
        ObjectStructure *o = [ObjectStructure new];
        [o.arr addObject:man];
        [o.arr addObject:woman];
        [o display:suc];
        
        return;
    }
    
    {
        XNPerson *p = [XNPerson new];
        p.name = @"helinyu";
        p.age = 18;
        XNStudent *stu = [XNStudent new];
        stu.name = @"son";
        p.student = stu;
        XNPerson *p1 = [p copy];
//        p1.name = @"ll";
//        p1.age = 23;
//        p1.student.name = @"2334";
        NSLog(@"lt - p name %@ , p1 name:%@",p.student.name, p1.student.name);
        NSLog(@"lt - p %p , %p1",p, p1);
        return;
    }
    
    {
        dispatch_async(dispatch_queue_create(nil, nil), ^{
            
        });
        
        NSArray *arr = @[@1, @2, @3, @4, @5, @6, @7, @8];
        [arr enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"lt current thread :%@",[NSThread currentThread]);
        }];
        
        dispatch_apply(arr.count, dispatch_get_global_queue(0, 0), ^(size_t index) {
            NSLog(@"lt - index:%zd, current thread :%@",index, [NSThread currentThread]);
        });
        NSLog(@"done ");
        return;
    }
    
    {
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        dispatch_apply(10, queue, ^(size_t index) {
            NSLog(@"lt - index:%zd, current thread :%@",index, [NSThread currentThread]);
        });
        NSLog(@"done ");
        return;
    }
    
    {
        dispatch_queue_t queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue, ^{
            NSLog(@"异步处理1m, %@",[NSThread currentThread]);
        });
        dispatch_async(queue, ^{
            NSLog(@"异步处理2, %@",[NSThread currentThread]);
        });
        dispatch_async(queue, ^{
            NSLog(@"异步处理3m, %@",[NSThread currentThread]);
        });
        dispatch_async(queue, ^{
            NSLog(@"异步处理4m, %@",[NSThread currentThread]);
        });
        dispatch_sync(queue, ^{
            NSLog(@"异步处理5m, %@",[NSThread currentThread]);
        });
        dispatch_sync(queue, ^{
            NSLog(@"异步处理6m, %@",[NSThread currentThread]);
        });
        return;
    }
    
    {
        dispatch_queue_t serialQueue1 = dispatch_queue_create("com.gcd.setTargetQueue2.serialQueue1", NULL);
        dispatch_queue_t serialQueue2 = dispatch_queue_create("com.gcd.setTargetQueue2.serialQueue2", NULL);
        dispatch_queue_t serialQueue3 = dispatch_queue_create("com.gcd.setTargetQueue2.serialQueue3", NULL);
        dispatch_queue_t serialQueue4 = dispatch_queue_create("com.gcd.setTargetQueue2.serialQueue4", NULL);
        dispatch_queue_t serialQueue5 = dispatch_queue_create("com.gcd.setTargetQueue2.serialQueue5", NULL);

        //创建目标串行队列 ,也就是将哪些队列放到这个队列里面执行
        dispatch_queue_t targetSerialQueue = dispatch_queue_create("com.gcd.setTargetQueue2.targetSerialQueue", NULL);
        
        //设置执行阶层
        dispatch_set_target_queue(serialQueue1, targetSerialQueue);
        dispatch_set_target_queue(serialQueue3, targetSerialQueue);
        dispatch_set_target_queue(serialQueue2, targetSerialQueue);
        dispatch_set_target_queue(serialQueue4, targetSerialQueue);
        dispatch_set_target_queue(serialQueue5, targetSerialQueue);
        
 
        dispatch_async(serialQueue1, ^{
            NSLog(@"1");
        });
        dispatch_async(serialQueue2, ^{
            NSLog(@"2");
        });
        dispatch_async(serialQueue3, ^{
            NSLog(@"3");
        });
        dispatch_async(serialQueue4, ^{
            NSLog(@"4");
        });
        dispatch_async(serialQueue5, ^{
            NSLog(@"5");
        });


//        serialQueue > dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0) >

        return;
    }
    
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMutiThread:) name:NSWillBecomeMultiThreadedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSingleThread:) name:NSDidBecomeSingleThreadedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onWillExitThread:) name:NSThreadWillExitNotification object:nil];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"lt - global , %@",[NSThread currentThread]);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"lt - main, %@", [NSThread currentThread]);
            });
        });
        
        dispatch_async(dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT), ^{
            NSLog(@"lt - test, %@",[NSThread currentThread]);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"lt - main 1, %@",[NSThread currentThread]);
            });
        });
        return;
    }
    
    {
        [self performSelectorInBackground:@selector(onSel) withObject:nil];// 执行后台线程
        [self performSelectorOnMainThread:@selector(onSel) withObject:nil waitUntilDone:NO]; // 执行主线程
    }
    
    {
        const char *text ="hello";
        void (^blk)(void) = ^(void) {
            printf("%c \n", text[2]);
        };
    }
    
    {
        NSMutableArray *array = [NSMutableArray array];
        void (^blk)(void) =^(void) {
            id obj = [NSObject new];
            [array addObject:obj];
        };
//
//        void (^blk1)(void) = ^(void) {
//            array = [NSMutableArray new];
//        };
    }

    {
        int dmy = 256;
        __block int val  = 10;
        __block const char *fmt = "val = %d \n";
        void (^blk)(void) = ^{
            printf(fmt, val);
        };
        val = 2;
        fmt = "These values were changed. val= %d \n";
        blk();
        return;
    }
    
    {
        XNPerson *p = [[XNPerson alloc] init];
        NSLog(@"lt p ; %p %p",p, &p);
        
        @autoreleasepool {
            
        }
        id __unsafe_unretained obj = [NSObject new];
    }
    
   {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0.f, 10,50, 50);
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(onTap) forControlEvents:UIControlEventTouchUpInside];}
    
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0.f, 120,50, 50);
        btn.backgroundColor = [UIColor redColor];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(onTap2) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0.f, 230,50, 50);
        btn.backgroundColor = [UIColor redColor];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(onTap1) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.arr = [NSMutableArray new];
        self.pointArr = [NSPointerArray weakObjectsPointerArray];
//        [self.arr addObject:@"12"];
//        [self.arr addObject:@"23"];
//
//        [self.pointArr addPointer:(__bridge void *)(self.arr.firstObject)];
//        [self.arr removeObjectAtIndex:0];
//        NSString *text = @"23354";
//        self.text = text;
        self.text = @"234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5234we5";
    }
    
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0.f, 340,50, 50);
        btn.backgroundColor = [UIColor blueColor];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(onTap3) forControlEvents:UIControlEventTouchUpInside];
    }
    
    {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0.f, 450,50, 50);
        btn.backgroundColor = [UIColor blueColor];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(onTap4) forControlEvents:UIControlEventTouchUpInside];
    }
    
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0.f, 550,50,50);
        btn.backgroundColor = [UIColor blueColor];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(onTap5) forControlEvents:UIControlEventTouchUpInside];
//
    }
    
    {
        XNPerson *person = [XNPerson new];
//        self.person = person;
        self.person.name= @"helinyu";
        self.person.age = 22;
        [self.pointArr addPointer:(void *)person];
        [self.pointArr addPointer:nil];
//        [self.arr addObject:self.person];
    }
    
    {

    }
}

- (void)onTap5 {
    XNFourthViewController *vc = [XNFourthViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTap4 {
    DecoratorViewController *vc = [DecoratorViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTap3 {
    XNThirdViewController *vc = [XNThirdViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTap {
    SecondViewController *vc = [SecondViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTap1 {
//    NSLog(@"ls :%zd",self.pointArr.count);
//    NSLog(@"ls :%@",[self.pointArr pointerAtIndex:0]);
//    NSLog(@"ls text:%@",self.text);
    for (XNPerson *person  in self.pointArr) {
        NSLog(@"lt point arr  :%@ , %zd",person.name, person.age);
    }

//    for (XNPerson *person in self.arr) {
//        NSLog(@"lt arr person :%@ , %zd",person.name, person.age);
//    }
//    NSLog(@"lt - person name;%@ ， age:%zd",self.person.name, self.person.age);
}

@end
