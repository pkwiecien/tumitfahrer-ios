//
//  SearchResultViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/9/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanoramioUtilities.h"

@interface SearchResultViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,  PanoramioUtilitiesDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger index;
@property (nonatomic, assign) ContentType RideType;
@property (nonatomic, strong) NSDictionary *queryParams;

@end
