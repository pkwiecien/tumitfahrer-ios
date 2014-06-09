//
//  ReminderViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/9/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
