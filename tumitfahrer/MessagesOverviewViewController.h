//
//  MessagesOverviewViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ride.h"

@interface MessagesOverviewViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Ride* ride;

- (IBAction)contactAllPassengersButtonPressed:(id)sender;

@end
