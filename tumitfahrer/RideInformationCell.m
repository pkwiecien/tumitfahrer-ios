//
//  RideInformationCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RideInformationCell.h"

@implementation RideInformationCell


+(RideInformationCell *)rideInformationCell {
    
    RideInformationCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"RideInformationCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor customLightGray];
    cell.contentView.backgroundColor = [UIColor customLightGray];

    return cell;
}

-(void)layoutSubviews {
    
}

@end
