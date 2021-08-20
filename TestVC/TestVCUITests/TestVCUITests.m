//
//  TestVCUITests.m
//  TestVCUITests
//
//  Created by xn on 2021/7/29.
//

#import <XCTest/XCTest.h>

@interface TestVCUITests : XCTestCase


@property (nonatomic, strong) XCUIApplication *app;

@end

@implementation TestVCUITests

- (void)setUp {
    
    self.app = [[XCUIApplication alloc] init];
    [self.app terminate];
    [self.app launch];
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}


// 看那一下UITest 是怎么测试的？
- (void)testPush {

}

- (void)testLaunchPerformance {

}

@end
