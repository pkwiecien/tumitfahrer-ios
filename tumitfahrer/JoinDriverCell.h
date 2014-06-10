//
//  JoinDriverCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/10/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JoinDriverCellDelegate <NSObject>

- (void)joinJoinDriverCellButtonPressed;
- (void)contactJoinDriverCellButtonPressed;

@end

@interface JoinDriverCell : UITableViewCell

+(JoinDriverCell *)joinDriverCell;

@property (nonatomic, strong) id<JoinDriverCellDelegate> delegate;

- (IBAction)joinButtonPressed:(id)sender;
- (IBAction)contactButtonPressed:(id)sender;

@end
