//
//  OfferRideCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/10/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol OfferRideCellDelegate <NSObject>

- (void)offerRideButtonPressed;

@end

@interface RideDetailActionCell : UITableViewCell

+(RideDetailActionCell *)offerRideCell;

@property (nonatomic, strong) id<OfferRideCellDelegate> delegate;

- (IBAction)offerRideButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end
