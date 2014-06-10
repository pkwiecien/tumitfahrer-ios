//
//  RequestActionCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/10/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RequestorActionCellDelegate <NSObject>

- (void)deleteRequestorActionCellButtonPressed;
- (void)editRequestorActionCellButtonPressed;

@end

@interface RequestorActionCell : UITableViewCell

+(RequestorActionCell *)requestorActionCell;

@property (nonatomic, strong) id<RequestorActionCellDelegate> delegate;

- (IBAction)editButtonPressed:(id)sender;
- (IBAction)deleteButtonPressed:(id)sender;

@end
