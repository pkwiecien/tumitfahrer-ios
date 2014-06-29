//
//  CurrentUserTests.m
//  tumitfahrer
//
//  Created by Automotive Service Lab on 16/05/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CurrentUser.h"
#import "Device.h"
#import "ActionManager.h"
#define TestNeedsToWaitForBlock() __block BOOL blockFinished = NO
#define BlockFinished() blockFinished = YES
#define WaitForBlock() while (!blockFinished){[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];}
@interface CurrentUserTests : XCTestCase

@end

@implementation CurrentUserTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFetchUserFromCoreDataWithEmailWithCorrectEmail
{
    //NSString *email = @"tumitfahrer@gmail.com";
    // TODO @Dansen: fix test (you should not assume that such user is in Core Data, but rather create a mock object, add it to core data and then then test the method
    // XCTAssertTrue([CurrentUser fetchUserFromCoreDataWithEmail:email] , @"Couldn't fetch the user from given email %@", email);
}

- (void)testFetchUserFromCoreDataWithEmailWithIncorrectEmail
{
    NSString *email = @"tum@tum.de";
    XCTAssertFalse([CurrentUser fetchUserFromCoreDataWithEmail:email] , @"Couldn't fetch the user from given email %@", email);
}

- (void)testFetchUserFromCoreDataWithEmailWithIncorrectInput
{
    NSString *email = @"abcde";
    XCTAssertFalse([CurrentUser fetchUserFromCoreDataWithEmail:email] , @"Couldn't fetch the user from given email %@", email);
}

- (void)testFetchUserFromCoreDataWithEmailWithEmptyEmail
{
    NSString *email = @"";
    XCTAssertFalse([CurrentUser fetchUserFromCoreDataWithEmail:email] , @"Couldn't fetch the user from given email %@", email);
}

- (void)testFetchUserFromCoreDataWithEmailAndPasswordWithCorrectPassword
{
    //NSString *email = @"tumitfahrer@gmail.com";
    //NSString *password = [ActionManager createSHA512:@"123456"];
    // TODO @Dansen: fix test (you should not assume that such user is in Core Data, but rather create a mock object, add it to core data and then then test the method
    // XCTAssertTrue([CurrentUser fetchUserFromCoreDataWithEmail:email encryptedPassword:password] , @"Couldn't fetch the user from given email %@ and paasword %@", email, password);
}

- (void)testFetchUserFromCoreDataWithEmailAndPasswordWithIncorrectPassword
{
    NSString *email = @"tum@tum.de";
    NSString *password = @"72b8c41f";
     XCTAssertFalse([CurrentUser fetchUserFromCoreDataWithEmail:email encryptedPassword:password] , @"Couldn't fetch the user from given email %@ and paasword %@", email, password);
}

- (void)testFetchUserFromCoreDataWithEmailAndPasswordWithIncorrectEmailInput
{
    NSString *email = @"abcde";
    NSString *password = @"abcde";
    XCTAssertFalse([CurrentUser fetchUserFromCoreDataWithEmail:email encryptedPassword:password] , @"Couldn't fetch the user from given email %@ and paasword %@", email, password);
}

- (void)testFetchUserFromCoreDataWithEmailAndPasswordWithEmptyPassword
{
    NSString *email = @"abcde";
    NSString *password = @"";
    XCTAssertFalse([CurrentUser fetchUserFromCoreDataWithEmail:email encryptedPassword:password] , @"Couldn't fetch the user from given email %@ and paasword %@", email, password);
}
#pragma mark - helper methods

- (CurrentUser *)createUniqueInstance {
    return [[CurrentUser alloc] init];
}

- (CurrentUser *)getSharedInstance {
    return [CurrentUser sharedInstance];
}

#pragma mark - test singleton

- (void)testSingletonSharedInstanceCreated {
    XCTAssertNotNil([self getSharedInstance]);
}

- (void)testSingletonUniqueInstanceCreated {
    XCTAssertNotNil([self createUniqueInstance]);
}

- (void)testSingletonReturnsSameSharedInstanceTwice {
    CurrentUser *s1 = [self getSharedInstance];
    XCTAssertEqual(s1, [self getSharedInstance]);
}

- (void)testSingletonSharedInstanceSeparateFromUniqueInstance {
    CurrentUser *s1 = [self getSharedInstance];
    XCTAssertNotEqual(s1, [self createUniqueInstance]);
}

- (void)testSingletonReturnsSeparateUniqueInstances {
    CurrentUser *s1 = [self createUniqueInstance];
    XCTAssertNotEqual(s1, [self createUniqueInstance]);
}

//- (void)testHasDeviceTokenInWebservice
//{
//    TestNeedsToWaitForBlock();
//    [[CurrentUser sharedInstance] hasDeviceTokenInWebservice:^(BOOL block) {
//        BlockFinished();
//        XCTAssertTrue(block, @"Incorrect");
//      // assertions
//    }];
//    
//    WaitForBlock();
//}

//- (void)testDeviceToken
//{
//    TestNeedsToWaitForBlock();
//    [[CurrentUser sharedInstance] hasDeviceTokenInWebservice:^(BOOL tokenExistsInDatabase) {
//        // device token is not in db, need to send it
//        if (!tokenExistsInDatabase && [CurrentUser sharedInstance].user.userId > 0) {
//            [[CurrentUser sharedInstance] sendDeviceTokenToWebservice];
//            BlockFinished();
//            XCTAssertTrue([[Device sharedInstance] deviceToken], "Token is false");
//        }
//    }];
//    WaitForBlock();
//
//}
@end
