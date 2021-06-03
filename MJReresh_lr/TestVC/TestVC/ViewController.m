//
//  ViewController.m
//  TestVC
//
//  Created by xn on 2021/5/27.
//

#import "ViewController.h"
#import "XNCustomView.h"
#import "XNSecondViewController.h"

@interface ViewController ()

@property (nonatomic, strong) XNCustomView *customView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:btn];
        btn.backgroundColor = [UIColor redColor];
        btn.frame = CGRectMake(100.f, 100.f, 50, 50.f);
        [btn addTarget:self action:@selector(onTest) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:btn];
        btn.backgroundColor = [UIColor greenColor];
        btn.frame = CGRectMake(200.f, 100.f, 100, 50.f);
        [btn addTarget:self action:@selector(onTest1) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)onTest1 {
    XNSecondViewController *vc = [XNSecondViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTest {
    if (self.customView) {
        [self.customView removeFromSuperview];
        self.customView = nil;
    }
    else {
        self.customView = [XNCustomView new];
        [self.view addSubview:self.customView];
        self.customView.frame = CGRectMake(100.f, 200.f, 100.f, 50.f);
        self.customView.backgroundColor = [UIColor yellowColor];
    }
}

@end
