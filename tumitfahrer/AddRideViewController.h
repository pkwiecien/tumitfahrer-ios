//
//  AddRideViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/23/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@class Ride;

@interface AddRideViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate>

typedef enum {
    Passenger = 0,
    Driver = 1
} TableTypeEnum;

typedef enum {
    TestValue = 0,
    SecondValue,
    ThirdValue,
} AddRideTableValue;

typedef NS_ENUM(NSUInteger, CellName) {
    DRIVER_ROLE_ENUM = 0,
    DRIVER_DEPARTURE_ENUM,
    DRIVER_DESTINATION_ENUM,
    DRIVER_DEPARTURE_TIME_ENUM,
    DRIVER_REPEAT_ENUM,
    DRIVER_SEATS_ENUM,
    DRIVER_CAR_ENUM,
    DRIVER_MEETING_POINT_ENUM,
    DRIVER_RIDE_TYPE_ENUM,
};

-(NSString *)stringForName:(CellName)paramName;

@property (nonatomic, strong) Ride *potentialRequestedRide;
@property (nonatomic, assign) ShouldDisplayEnum displayEnum;
@property (nonatomic, assign) AddRideTableValue addRideTableValue;
@property (nonatomic, assign) TableTypeEnum TableType;
@property (nonatomic, assign) ContentType RideType;
@property (nonatomic, assign) DisplayType RideDisplayType;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableValues;
@property BOOL shouldClose;

@end
