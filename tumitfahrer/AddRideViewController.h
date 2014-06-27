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
