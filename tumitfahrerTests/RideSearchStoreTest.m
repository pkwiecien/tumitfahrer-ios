//
//  RideSearchStoreTest.m
//  tumitfahrer
//
//  Created by Automotive Service Lab on 16/05/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RideSearch.h"
#import "RideSearchStore.h"
#import "Ride.h"
@interface RideSearchStoreTest : XCTestCase

@end

@implementation RideSearchStoreTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
//    Ride *ride = [[Ride alloc]init];
//    [ride setRideId:20];
//    
//    RideSearch *ridesearch = [[RideSearch alloc]init];
//    [ridesearch setRideId:20];
//    [ridesearch setDriverId:1];
//    [[RideSearchStore sharedStore] addSearchResult:ridesearch];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRideWithCorrectId
{
    NSInteger rideId = 34;
    RideSearch *result = [[RideSearchStore sharedStore]rideWithId:rideId];
    XCTAssertEqual(result.driverId,0, @"Ride is empty with ride id %ld",(long)rideId);
}


- (void)testRideWithInCorrectId
{
    NSInteger rideId = -1;
    RideSearch *result = [[RideSearchStore sharedStore]rideWithId:rideId];
    XCTAssertNil(result, @"Ride is empty with ride id %ld",(long)rideId);
}

- (void)testAddSearchResult
{
    
}

#pragma mark - helper methods

- (RideSearchStore *)createUniqueInstance {
    
    return [[RideSearchStore alloc] init];
    
}

- (RideSearchStore *)getSharedInstance {
    
    return [RideSearchStore sharedStore];
    
}

#pragma mark - test singleton

- (void)testSingletonSharedInstanceCreated {
    
    XCTAssertNotNil([self getSharedInstance]);
    
}

- (void)testSingletonUniqueInstanceCreated {
    
    XCTAssertNotNil([self createUniqueInstance]);
    
}

- (void)testSingletonReturnsSameSharedInstanceTwice {
    
    RideSearchStore *s1 = [self getSharedInstance];
    XCTAssertEqual(s1, [self getSharedInstance]);
    
}

- (void)testSingletonSharedInstanceSeparateFromUniqueInstance {
    
    RideSearchStore *s1 = [self getSharedInstance];
    XCTAssertNotEqual(s1, [self createUniqueInstance]);
}

- (void)testSingletonReturnsSeparateUniqueInstances {
    
    RideSearchStore *s1 = [self createUniqueInstance];
    XCTAssertNotEqual(s1, [self createUniqueInstance]);
}
@end
