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

@class DestinationViewController;

@interface AddRideViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MeetingPointDelegate, DestinationViewControllerDelegate>

@property (nonatomic, assign) ContentType RideType;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
