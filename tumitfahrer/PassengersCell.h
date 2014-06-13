//
//  PassengersCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol PassengersCellDelegate <NSObject>

-(void)passengerCellChangedForPassenger:(User *)passenger;

@end

@interface PassengersCell : UITableViewCell

+(PassengersCell*)passengersCell;

@property (nonatomic, strong) id<PassengersCellDelegate> delegate;

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSNumber *rideId;

@property (weak, nonatomic) IBOutlet UILabel *passengerName;
@property (weak, nonatomic) IBOutlet UIImageView *passengerImage;
@property (weak, nonatomic) IBOutlet UIButton *passengerContact;
@property (weak, nonatomic) IBOutlet UIButton *passengerAccept;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (IBAction)removeButtonPressed:(id)sender;

@end
