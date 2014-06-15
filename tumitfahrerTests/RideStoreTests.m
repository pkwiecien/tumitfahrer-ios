//
//  RideStoreTests.m
//  tumitfahrer
//
//  Created by Automotive Service Lab on 16/05/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RidesStore.h"
#import "Ride.h"
#import "CurrentUser.h"
#import "CoreDataHelper.h"

@interface RideStoreTests : XCTestCase

@property (nonatomic, strong) Ride *campusRide;
@property (nonatomic, strong) Ride *activityRide;
@property (nonatomic, strong) User *user;
@end

@implementation RideStoreTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.campusRide = [NSEntityDescription insertNewObjectForEntityForName:@"Ride" inManagedObjectContext:[CoreDataHelper managedObjectContextForTests]];
    [self.campusRide setRideId:[NSNumber numberWithInt:12]];
    //ride.departureTime
    [self.campusRide setDeparturePlace:@"garching"];
    [self.campusRide setDestination:@"munich"];
    [self.campusRide setFreeSeats:[NSNumber numberWithInt:2]];
    [self.campusRide setMeetingPoint:@"fmi"];
    [self.campusRide setRideType:0];
    
    self.activityRide = [NSEntityDescription insertNewObjectForEntityForName:@"Ride" inManagedObjectContext:[CoreDataHelper managedObjectContextForTests]];
    [self.activityRide setRideId:[NSNumber numberWithInt:13]];
    //ride.departureTime
    [self.activityRide setDeparturePlace:@"garching"];
    [self.activityRide setDestination:@"berlin"];
    [self.activityRide setFreeSeats:[NSNumber numberWithInt:5]];
    [self.activityRide setMeetingPoint:@"fmi"];
    [self.activityRide setRideType:[NSNumber numberWithInt:1]];
    
    [[RidesStore sharedStore] addRideToStore:self.campusRide];
    [[RidesStore sharedStore] addRideToStore:self.activityRide];
}

- (void)testFetchRidesFromCoreDataByTypeCampusRides
{
    //ContentType content = ContentTypeCampusRides;
//    [[RidesStore sharedStore] loadRidesFromCoreDataByType:content];
    // TODO @Dansen: fix test
    // XCTAssertTrue([[[RidesStore sharedStore] allCampusRides] count]>0, "Could not fetch the correct rides");
}

- (void)testFetchRidesFromCoreDataByTypeActivityRides
{
//        ContentType content = ContentTypeActivityRides;
//        [[RidesStore sharedStore] ];
////    // TODO @Dansen: fix test
//        XCTAssertTrue([[[RidesStore sharedStore] allActivityRides] count]>0, "Could not fetch the correct rides");
}

//- (void)testAllRidesByTypeActivityRides
//{
//    ContentType content = ContentTypeActivityRides;
//    [[RidesStore sharedStore] fetchRidesFromCoreDataByType:content];
//    XCTAssertTrue([[[RidesStore sharedStore] allActivityRides] count]>0, "Could not fetch the correct rides");
//}
//
//- (void)testAllRidesByTypeCampusRides
//{
//    ContentType content = ContentTypeActivityRides;
//    [[RidesStore sharedStore] fetchRidesFromCoreDataByType:content];
//    XCTAssertTrue([[[RidesStore sharedStore] ] count]>0, "Could not fetch the correct rides");
//}


//- (void)testDeleteRideFromCoreData
//{
//    NSInteger rideId = [self.campusRide rideId];
//    [[RidesStore sharedStore]deleteRideFromCoreData:self.campusRide];
//    Ride *expected = [[RidesStore sharedStore]containsRideWithId:rideId];
//    XCTAssertNil(expected, "Fail to delete ride with id %ld",(long)rideId);
//}

- (void)testContainsRideWithId {
    Ride *expected = [[RidesStore sharedStore]containsRideWithId:[NSNumber numberWithInt:13]];
    XCTAssertNotNil(expected, "All rides do not contain ride with id %@", expected.rideId);
}

- (void)testRidesNearbyByTypeWithActivityRides
{
    NSArray *expected = [[RidesStore sharedStore]ridesNearbyByType:ContentTypeActivityRides];
    XCTAssertNotNil(expected, "fail to get nearby rides of activity rides");
}

- (void)testRidesNearbyByTypeWithCampusRides
{
    NSArray *expected = [[RidesStore sharedStore]ridesNearbyByType:ContentTypeCampusRides];
    XCTAssertNotNil(expected, "fail to get nearby rides of campus rides");
}

- (void)testFavoriteRidesByTypeWithActivityRides
{
    NSArray *expected = [[RidesStore sharedStore]favoriteRidesByType:ContentTypeActivityRides];
    XCTAssertNotNil(expected, "fail to get favorite rides of campus rides");
}

- (void)testFavoriteRidesByTypeWithCampusRides
{
    NSArray *expected = [[RidesStore sharedStore]favoriteRidesByType:ContentTypeCampusRides];
    XCTAssertNotNil(expected, "fail to get favorite rides of campus rides");
}
#pragma mark - helper methods

- (RidesStore *)createUniqueInstance {
    
    return [[RidesStore alloc] init];
    
}

- (RidesStore *)getSharedInstance {
    
    return [RidesStore sharedStore];
    
}

#pragma mark - test singleton

- (void)testSingletonSharedInstanceCreated {
    
    XCTAssertNotNil([self getSharedInstance]);
    
}

- (void)testSingletonUniqueInstanceCreated {
    
    XCTAssertNotNil([self createUniqueInstance]);
    
}

- (void)testSingletonReturnsSameSharedInstanceTwice {
    
    RidesStore *s1 = [self getSharedInstance];
    XCTAssertEqual(s1, [self getSharedInstance]);
    
}

- (void)testSingletonSharedInstanceSeparateFromUniqueInstance {
    
    RidesStore *s1 = [self getSharedInstance];
    XCTAssertNotEqual(s1, [self createUniqueInstance]);
}

- (void)testSingletonReturnsSeparateUniqueInstances {
    
    RidesStore *s1 = [self createUniqueInstance];
    XCTAssertNotEqual(s1, [self createUniqueInstance]);
}

@end
