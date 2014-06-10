//
//  EideRequestViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/10/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingPointViewController.h"
#import "DestinationViewController.h"
#import "RMDateSelectionViewController.h"

@class Ride;

@interface EditRequestViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MeetingPointDelegate, DestinationViewControllerDelegate, RMDateSelectionViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Ride *ride;

@end
