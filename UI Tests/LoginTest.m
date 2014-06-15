//
//  LoginTest.m
//  tumitfahrer
//
//  Created by Automotive Service Lab on 15/06/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "LoginTest.h"

//#import "KIF/KIFUITestActor+EXAdditions.h"

@implementation LoginTest : KIFTestCase

- (void)beforeEach
{
    //[tester navigateToLoginPage];
}

- (void)afterEach
{
    //[tester returnToLoggedOutHomeScreen];
}

//- (void)testSuccessfulLogin
//{
//    [tester enterText:@"tumitfahrer@gmail.com" intoViewWithAccessibilityLabel:@"Login Email"];
//    [tester enterText:@"123456" intoViewWithAccessibilityLabel:@"Login Password"];
//    [tester tapViewWithAccessibilityLabel:@"Login Button"];
//    
//    // Verify that the login succeeded
//    [tester waitForTappableViewWithAccessibilityLabel:@"Timeline View"];
//}
@end
