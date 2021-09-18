//
//  XNFiveViewViewController.m
//  TestVC
//
//  Created by xn on 2021/9/18.
//

#import "XNFiveViewViewController.h"

@interface XNFiveViewViewController ()

@property (nonatomic, strong) NSThread *aThred;

@end

@implementation XNFiveViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
}


- (void)test {
    NSThread *aThread = [[NSThread alloc] initWithTarget:self selector:@selector(testForCustomSource) object:nil];
    self.aThred = aThread;
    [aThread start];
}

- (void)testForCustomSource {
    
}

@end
