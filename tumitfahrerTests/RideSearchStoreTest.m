////
////  RideSearchStoreTest.m
////  tumitfahrer
////
////  Created by Automotive Service Lab on 16/05/14.
////  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
////
//
//#import <XCTest/XCTest.h>
//#import "RideSearch.h"
//#import "RideSearchStore.h"
//#import "Ride.h"
//@interface RideSearchStoreTest : XCTestCase
//@property (nonatomic) RideSearch *rideSearch;
//@end
//
//@implementation RideSearchStoreTest
//
//- (void)setUp
//{
//    [super setUp];
//    // Put setup code here. This method is called before the invocation of each test method in the class.
//    self.rideSearch = [[RideSearch alloc]init];
//    [self.rideSearch setRideId:[NSNumber numberWithInt:12]];
//    //ride.departureTime
//    [self.rideSearch setDeparturePlace:@"garching"];
//    [self.rideSearch setDestination:@"munich"];
//    [self.rideSearch setFreeSeats:2];
//    [self.rideSearch setMeetingPoint:@"fmi"];
//    [self.rideSearch setRideType:0];
//    
//    [[RideSearchStore sharedStore] addSearchResult:self.rideSearch];
//}
//
//- (void)tearDown
//{
//    // Put teardown code here. This method is called after the invocation of each test method in the class.
//    [super tearDown];
//}
//
//- (void)testRideWithCorrectId
//{
//    NSNumber *rideId = [NSNumber numberWithInt:34];
//    RideSearch *result = [[RideSearchStore sharedStore]rideWithId:rideId];
//    XCTAssertEqual(result.driverId,0, @"Ride is empty with ride id %ld",(long)rideId);
//}
//
//
//- (void)testRideWithInCorrectId
//{
//    NSNumber *rideId = [NSNumber numberWithInt:-1];
//    RideSearch *result = [[RideSearchStore sharedStore]rideWithId:rideId];
//    XCTAssertNil(result, @"Ride is empty with ride id %ld",(long)rideId);
//}
//
//- (void)testAddSearchResult
//{
//    
//    RideSearch *expected = [[RideSearchStore sharedStore] rideWithId:self.rideSearch.rideId];
//    XCTAssertEqual(self.rideSearch.destination, expected.destination, "Fetch the wrong ride with ride ids are %@ ,%@",self.rideSearch.rideId,expected.rideId);
//}
//
//- (void)testAllSearchResult
//{
//    NSArray *expected = [[RideSearchStore sharedStore] allSearchResults];
//    XCTAssertNotNil(expected, "Could not fetch all search results");
//}
//
//#pragma mark - helper methods
//
//- (RideSearchStore *)createUniqueInstance {
//    
//    return [[RideSearchStore alloc] init];
//    
//}
//
//- (RideSearchStore *)getSharedInstance {
//    
//    return [RideSearchStore sharedStore];
//    
//}
//
//#pragma mark - test singleton
//
//- (void)testSingletonSharedInstanceCreated {
//    
//    XCTAssertNotNil([self getSharedInstance]);
//    
//}
//
//- (void)testSingletonUniqueInstanceCreated {
//    
//    XCTAssertNotNil([self createUniqueInstance]);
//    
//}
//
//- (void)testSingletonReturnsSameSharedInstanceTwice {
//    
//    RideSearchStore *s1 = [self getSharedInstance];
//    XCTAssertEqual(s1, [self getSharedInstance]);
//    
//}
//
//- (void)testSingletonSharedInstanceSeparateFromUniqueInstance {
//    
//    RideSearchStore *s1 = [self getSharedInstance];
//    XCTAssertNotEqual(s1, [self createUniqueInstance]);
//}
//
//- (void)testSingletonReturnsSeparateUniqueInstances {
//    
//    RideSearchStore *s1 = [self createUniqueInstance];
//    XCTAssertNotEqual(s1, [self createUniqueInstance]);
//}
//@end
