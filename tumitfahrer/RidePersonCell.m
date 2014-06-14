//
//  RidePersonCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/14/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RidePersonCell.h"

@implementation RidePersonCell

+(RidePersonCell *)ridePersonCell {
    
    RidePersonCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"RidePersonCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor customLightGray];
    
    return cell;
}

- (void)awakeFromNib {

}

- (IBAction)leftButtonPressed:(id)sender {
    
}
- (IBAction)rightButtonPressed:(id)sender {
    
}

@end
