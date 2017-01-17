//
//  MultipleInfowindowsUITests.m
//  MultipleInfowindowsUITests
//
//  Created by eidan on 17/1/17.
//  Copyright © 2017年 AutoNavi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MAMapUITestHelper.h"

@interface MultipleInfowindowsUITests : XCTestCase

@end

@implementation MultipleInfowindowsUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [app.buttons[@"开始"] tap];
    
    sleep(2);
    
    //获取所有的infoWindowView
    XCUIElementQuery *allInfoView = [app.otherElements containingType:XCUIElementTypeAny identifier:@"CustomInfoWindowView"];
    NSInteger infoViewCount = allInfoView.count;
    
    XCTAssert(infoViewCount > 1, @"数量应该大于1的");
    
    if (infoViewCount > 1) {
        XCUIElement *infoView1 = [allInfoView elementBoundByIndex:0];
        [infoView1 tap];
        
        [MAMapUITestHelper checkAlertWithTitleText:@"InfoWindowView" cancelBtnText:@"OK" app:app test:self success:^{
            
            sleep(1);
            
            XCUIElement *infoView2 = [allInfoView elementBoundByIndex:allInfoView.count - 1];
            [infoView2 tap];
            
            [MAMapUITestHelper checkAlertWithTitleText:@"InfoWindowView" cancelBtnText:@"OK" app:app test:self success:^{
                
                XCTestExpectation *e = [self expectationWithDescription:@"empty wait"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [e fulfill];
                });
                [self waitForExpectationsWithTimeout:5 handler:nil];
                
            } failure:^{
                XCTAssertFalse(@"第二个弹框出现失败");
            }];
            
            
        } failure:^{
            XCTAssertFalse(@"第一个弹框出现失败");
        }];
        
    }
    
    
}

@end
