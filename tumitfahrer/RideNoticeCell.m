//
//  RideNoticeCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/6/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RideNoticeCell.h"

@implementation RideNoticeCell


+ (RideNoticeCell *)rideNoticeCell {
    RideNoticeCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"RideNoticeCell" owner:self options:nil] objectAtIndex:0];
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

    // Configure the view for the selected state
}

@end
