//
//  YourRidesViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/4/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@protocol YourRidesViewControllerDelegate

-(void)willAppearViewWithIndex:(NSInteger)index;

@end

@interface YourRidesViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) id<YourRidesViewControllerDelegate> delegate;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end
