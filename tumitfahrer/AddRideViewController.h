//
//  AddRideViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/23/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingPointViewController.h"
#import "DestinationViewController.h"
#import "FreeSeatsTableViewCell.h"
#import "RMDateSelectionViewController.h"

@class DestinationViewController;

@interface AddRideViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MeetingPointDelegate, DestinationViewControllerDelegate, FreeSeatsCellDelegate, RMDateSelectionViewControllerDelegate>

typedef enum {
    Passenger = 0,
    Driver = 1
} TableTypeEnum;

@property (nonatomic, assign) TableTypeEnum TableType;
@property (nonatomic, assign) ContentType RideType;
@property (nonatomic, assign) DisplayType RideDisplayType;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
