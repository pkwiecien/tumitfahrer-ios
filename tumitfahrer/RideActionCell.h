//
//  DetailsMessagesChoiceCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailsMessagesChoiceCellDelegate <NSObject>

- (void)contactDriverButtonPressed;
- (void)joinRideButtonPressed;

@end

@interface RideActionCell : UITableViewCell

+(RideActionCell *)detailsMessagesChoiceCell;

@property (weak, nonatomic) IBOutlet UIButton *joinRideButton;
@property (weak, nonatomic) IBOutlet UIButton *contactDriverButton;
@property (nonatomic, strong) id<DetailsMessagesChoiceCellDelegate> delegate;

- (IBAction)contactDriverButtonPressed:(id)sender;
- (IBAction)joinRideButtonPressed:(id)sender;

@end
