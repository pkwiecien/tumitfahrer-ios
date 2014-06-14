//
//  OfferRideCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/10/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RideDetailActionCell.h"

@implementation RideDetailActionCell

+(RideDetailActionCell *)offerRideCell {
    RideDetailActionCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"RideDetailActionCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor customLightGray];
    
    return cell;
}

- (IBAction)offerRideButtonPressed:(id)sender {
    [self.delegate  offerRideButtonPressed];
}

@end
