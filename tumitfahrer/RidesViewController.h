//
//  RidesViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RidesViewControllerDelegate

-(void)willAppearViewWithIndex:(NSInteger)index;

@end

@interface RidesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) id<RidesViewControllerDelegate> delegate;
@property (assign, nonatomic) NSInteger index;

@end
