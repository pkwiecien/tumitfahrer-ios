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
    cell.driverImageView.image = [ActionManager colorImage:[UIImage imageNamed:@"DriverIcon"] withColor:[UIColor whiteColor]];
    cell.passengerImageView.image = [ActionManager colorImage:[UIImage imageNamed:@"PassengerIcon"] withColor:[UIColor whiteColor]];
    cell.ratingImageView.image = [ActionManager colorImage:[UIImage imageNamed:@"StarIcon"] withColor:[UIColor whiteColor]];
    
    return cell;
}


@end
