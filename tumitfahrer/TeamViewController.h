//
//  TeamViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/15/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface TeamViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
