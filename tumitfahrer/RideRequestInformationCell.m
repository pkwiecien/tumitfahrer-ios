//
//  RideRequestInformationCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/31/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RideRequestInformationCell.h"

@implementation RideRequestInformationCell

+(RideRequestInformationCell *)rideRequestInformationCell {
    
    RideRequestInformationCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"RideRequestInformationCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor customLightGray];
    cell.contentView.backgroundColor = [UIColor customLightGray];
    
    return cell;
}


@end
