//
//  OfferRideCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/10/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "OfferRideCell.h"

@implementation OfferRideCell

+(OfferRideCell *)offerRideCell {
    OfferRideCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"OfferRideCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor customLightGray];
    
    return cell;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)joinButtonPressed:(id)sender {
    [self.delegate  joinOfferRideCellButtonPressed];
}

@end
