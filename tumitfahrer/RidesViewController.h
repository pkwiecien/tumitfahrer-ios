//
//  RidesViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanoramioUtilities.h"
#import "RidesStore.h"

@protocol RidesViewControllerDelegate

-(void)willAppearViewWithIndex:(NSInteger)index;

@end

@interface RidesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,  PanoramioUtilitiesDelegate, RideStoreDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) id<RidesViewControllerDelegate> delegate;
@property (assign, nonatomic) NSInteger index;
@property (nonatomic, assign) ContentType RideType;


@end
