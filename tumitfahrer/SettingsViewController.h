//
//  CampusRidesViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/1/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SlideNavigationController.h>

@interface SettingsViewController : UIViewController <SlideNavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendFeedbackButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (nonatomic, strong) UITableView *tableView;

- (IBAction)sendFeedbackButtonPressed:(id)sender;
- (IBAction)logoutButtonPressed:(id)sender;

@end
