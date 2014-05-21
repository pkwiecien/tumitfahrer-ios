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

@interface RideStoreTests : XCTestCase

@property (nonatomic, strong) Ride *ride;
@property (nonatomic) NSInteger rideID;
@end

@implementation RideStoreTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSDictionary *queryParams;
    // add enum
    NSString *departurePlace = @"munich";
    NSString *destination = @"garching";
    NSString *freeSeats = @"2";
    NSString *meetingPoint = @"fmi";
    if (!departurePlace || !destination || !meetingPoint) {
        return;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    NSString *now = [formatter stringFromDate:[NSDate date]];
    
    queryParams = @{@"departure_place": departurePlace, @"destination": destination, @"departure_time": now, @"free_seats": freeSeats, @"meeting_point": meetingPoint, @"ride_type": [NSNumber numberWithInt:ContentTypeCampusRides]};
    NSDictionary *rideParams = @{@"ride": queryParams};
    
    [[[RKObjectManager sharedManager] HTTPClient] setDefaultHeader:@"apiKey" value:[[CurrentUser sharedInstance] user].apiKey];
    
    [objectManager postObject:nil path:@"/api/v2/rides" parameters:rideParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        self.ride = (Ride *)[mappingResult firstObject];
        self.rideID = [self.ride rideId];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
         RKLogError(@"Load failed with error: %@", error);
     }];
}

- (void)testFetchRidesFromCoreDataByType
{
    ContentType content = ContentTypeCampusRides;
    [[RidesStore sharedStore] fetchRidesFromCoreDataByType:content];
    //Ride *tmpRide = [[RidesStore sharedStore] getRideWithId:self.rideID];
    //XCTAssertTrue([[[RidesStore sharedStore] allCampusRides] containsObject:tmpRide], "Could not fetch the correct rides");
    XCTAssertTrue([[[RidesStore sharedStore] allCampusRides] count]>0, "Could not fetch the correct rides");
}

- (void)testFetchUserRequestedRidesFromCodeData
{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
//    NSString *now = [formatter stringFromDate:[NSDate date]];
    Ride *ride = [[Ride alloc]init];
    [ride setRideId:12];
    //ride.departureTime
    [ride setDeparturePlace:@"garching"];
    [ride setDestination:@"munich"];
    [ride setFreeSeats:2];
    [ride setMeetingPoint:@"fmi"];
    [ride setRideType:0];
    
    Ride *expected = [[RidesStore sharedStore] getRideWithId:ride.rideId];
    XCTAssertEqual(ride, expected, "Fetch the wrong ride with ride ids are %d ,%d",ride.rideId,expected.rideId);
}

@end
