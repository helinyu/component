//
//  XNThirdViewController.m
//  TestVC
//
//  Created by xn on 2021/8/23.
//

#import "XNThirdViewController.h"
#import "XNPerson.h"

@interface XNThirdViewController ()

@end

@implementation XNThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XNPerson *person = [XNPerson new];
    @synchronized (person) {
        
    }
}


@end
