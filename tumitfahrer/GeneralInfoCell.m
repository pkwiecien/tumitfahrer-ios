//
//  GeneralInfoCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/19/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "GeneralInfoCell.h"
#import "ActionManager.h"

@implementation GeneralInfoCell

+(GeneralInfoCell *)generalInfoCell {
    
    GeneralInfoCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"GeneralInfoCell" owner:self options:nil] objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor lightestBlue];
    cell.driverImageView.image = [UIImage imageNamed:@"DriverIconBig"];
    cell.passengerImageView.image = [UIImage imageNamed:@"PassengerIconMiddle"];
    cell.ratingImageView.image = [UIImage imageNamed:@"RatingIconBig"];
    
    return cell;
}


@end
