//
//  XNBlockModel.m
//  TestVC
//
//  Created by xn on 2021/9/13.
//

#import "XNBlockModel.h"
#import "XNPerson.h"

@interface XNBlockModel ()

@property (nonatomic, strong) XNPerson *p1;

@end

@implementation XNBlockModel

- (void)initTest {
    {
        XNPerson *p1 = [XNPerson new];
        self.p1 = p1;
        void (^block)(void);
        int a = 2;
        if (a > 1){
            block = ^(void) {
                NSLog(@"aae");
                NSLog(@"lt - person :%@",p1);
                self.p1.name = @"hel;inyu";
            };
        }
        else {
            block = ^(void) {
                NSLog(@"bbb");
            };
        }
        block();
    }
}

@end
