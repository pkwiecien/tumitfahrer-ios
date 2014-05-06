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
#import "SlideNavigationController.h"
#import "FreeSeatsTableViewCell.h"

@class DestinationViewController;

@interface AddRideViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MeetingPointDelegate, DestinationViewControllerDelegate, SlideNavigationControllerDelegate, FreeSeatsCellDelegate>

typedef enum showTypes : NSUInteger {
    ShowAsModal = 0,
    ShowAsViewController = 1,
} AddRideDisplayType;

@property (nonatomic, assign) ContentType RideType;
@property (nonatomic, assign) AddRideDisplayType DisplayType;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
