//
//  XNFiveViewViewController.m
//  TestVC
//
//  Created by xn on 2021/9/18.
//

#import "XNFiveViewViewController.h"
#import <mach-o/dyld.h>

@interface XNFiveViewViewController ()

@end

@implementation XNFiveViewViewController


static void _rebind_symbols_for_image(const struct mach_header *header,
                                      intptr_t slide) {
//    rebind_symbols_for_image(_rebindings_head, header, slide);
    NSLog(@"lt -");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(100.f, 200.f, 100.f, 100.f);
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(onTap) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTap {
    uint32_t count = _dyld_image_count(); // 动态映射库的数目
    for (NSInteger index = 0; index < count; index++) {
        struct mach_header* header = _dyld_get_image_header(index);
        intptr_t  slide = _dyld_get_image_vmaddr_slide(index);
        char* image_name = _dyld_get_image_name(index);
        NSLog(@"lt image_name：%s",image_name);
        uint32_t ptr = NSVersionOfRunTimeLibrary("libBacktraceRecording");
        NSLog(@"lt - ptr :%d",ptr);
    }
    
    _dyld_register_func_for_add_image(_rebind_symbols_for_image);
}


@end
