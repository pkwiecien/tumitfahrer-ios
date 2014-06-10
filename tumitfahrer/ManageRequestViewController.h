//
//  ManageRequestViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/10/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Ride;
@interface ManageRequestViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Ride* ride;

@end
