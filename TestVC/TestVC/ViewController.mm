//
//  ViewController.m
//  TestVC
//
//  Created by xn on 2021/7/29.
//

#import "ViewController.h"
#import <MMKV/MMKV.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    uint32_t value = 10;
    
    uint8_t val = static_cast<uint8_t>(value);
    NSLog(@"lt :value :%d, val:%d",value, val);

//    [[MMKV defaultMMKV] setBool:YES forKey:@"yes"];
//    [[MMKV defaultMMKV] getBoolForKey:@"yes"];
    [[MMKV defaultMMKV] setInt32:10 forKey:@"123"];
    [[MMKV defaultMMKV] setInt64:10 forKey:@"12"];
    NSInteger val1 = [[MMKV defaultMMKV] getUInt32ForKey:@"123"];
    NSLog(@"val 1:%d",val1);
//
//
//    [[MMKV defaultMMKV] setData:[NSData new] forKey:@"data"];
//    [[MMKV defaultMMKV] setString:@"lll" forKey:@"11key"];
//    [[MMKV defaultMMKV] setDate:[NSDate new] forKey:@"date"];
}


@end
