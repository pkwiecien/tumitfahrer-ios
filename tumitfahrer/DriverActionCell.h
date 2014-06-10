//
//  DetailsMessagesChoiceCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DriverActionCellDelegate <NSObject>

- (void)deleteDriverActionCellButtonPressed;
- (void)peopleDriverActionCellButtonPressed;
- (void)editDriverActionCellButtonPressed;
- (void)contactDriverActionCellButtonPressed;

@end

@interface DriverActionCell : UITableViewCell

+(DriverActionCell *)driverActionCell;

@property (nonatomic, strong) id<DriverActionCellDelegate> delegate;

- (IBAction)peopleButtonPressed:(id)sender;
- (IBAction)contactButtonPressed:(id)sender;
- (IBAction)deleteButtonPressed:(id)sender;
- (IBAction)editButtonPressed:(id)sender;

@end
