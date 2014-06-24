//
//  SearchRideViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/23/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface SearchRideViewController : GAITrackedViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) DisplayType SearchDisplayType;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)dismissKeyboard:(id)sender;

@end
