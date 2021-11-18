//
//  XNFiveViewViewController.m
//  TestVC
//
//  Created by xn on 2021/9/18.
//

#import "XNFiveViewViewController.h"
#import <mach-o/dyld.h>
#import "fishhook.h"

@interface XNFiveViewViewController ()

@end

@implementation XNFiveViewViewController


//static void _rebind_symbols_for_image(const struct mach_header *header,
//                                      intptr_t slide) {
////    rebind_symbols_for_image(_rebindings_head, header, slide);
//    NSLog(@"lt -");
//}


void (*sys_nslog)(NSString *format, ...);
void myNSLog(NSString *format) {
    sys_nslog(@"rebind 到这里了");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addView];
    
    NSLog(@"log");
    
    struct rebinding nslog;
    nslog.name = "NSLog"; // 需要HOOk的函数名称
    nslog.replacement = myNSLog; // 新函数的地址
    nslog.replaced = (void *)&sys_nslog; // 原始函数指针
    
//     准备数组，将一个或多个rebinding结构体放进去
    struct rebinding rebs[1] = {nslog};
// rebindings ：存放rebinding结构体的数组
// rebindings_nel： 数据的数目
    rebind_symbols(rebs, 1);
}

- (void)onTap {
    NSLog(@"NSLog 输出");
    
//    uint32_t count = _dyld_image_count(); // 动态映射库的数目
//    for (NSInteger index = 0; index < count; index++) {
//        struct mach_header* header = _dyld_get_image_header(index);
//        intptr_t  slide = _dyld_get_image_vmaddr_slide(index);
//        char* image_name = _dyld_get_image_name(index);
//        NSLog(@"lt image_name：%s",image_name);
//        uint32_t ptr = NSVersionOfRunTimeLibrary("libBacktraceRecording");
//        NSLog(@"lt - ptr :%d",ptr);
//    }
//
//    _dyld_register_func_for_add_image(_rebind_symbols_for_image);
}

- (void)addView {
    self.view.backgroundColor = [UIColor orangeColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(100.f, 200.f, 100.f, 100.f);
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(onTap) forControlEvents:UIControlEventTouchUpInside];
}


@end
