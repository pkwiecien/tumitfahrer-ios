//
//  PassengersCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "PassengersCell.h"
#import "ActionManager.h"
#import "WebserviceRequest.h"

@implementation PassengersCell

+(PassengersCell *)passengersCell {
    PassengersCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PassengersCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

- (IBAction)removeButtonPressed:(id)sender {
    
    [WebserviceRequest removePassengerWithId:self.user.userId rideId:self.rideId block:^(BOOL fetched) {
        if (fetched) {
            [self.delegate passengerCellChangedForPassenger:self.user];
        }
    }];
    
}

@end
