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

@interface ViewController ()

@property (nonatomic, strong) NSPointerArray *pointArr;
@property (nonatomic, strong) NSMutableArray *arr;

@property (nonatomic, weak) NSString *text;

@property (nonatomic, weak) XNPerson *person;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   { UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0.f, 10,100, 100);
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(onTap) forControlEvents:UIControlEventTouchUpInside];}
    
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0.f, 120,100, 100);
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
        XNPerson *person = [XNPerson new];
//        self.person = person;
        self.person.name= @"helinyu";
        self.person.age = 22;
        [self.pointArr addPointer:(void *)person];
        [self.pointArr addPointer:nil];
//        [self.arr addObject:self.person];
    }
}

- (void)onTap {
    SecondViewController *vc = [SecondViewController new];
    [self presentViewController:vc animated:YES completion:nil];
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
