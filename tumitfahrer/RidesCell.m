//
//  RidesCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RidesCell.h"
#import "ActionManager.h"

@implementation RidesCell

+(RidesCell *)ridesCell {
    RidesCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"RidesCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIColor *color = [UIColor colorWithRed:0.808 green:0.808 blue:0.808 alpha:1];
    
    cell.timeImageView.image = [ActionManager colorImage:[UIImage imageNamed:@"TimeIcon"] withColor:color];
    cell.calendarImageView.image = [ActionManager colorImage:[UIImage imageNamed:@"CalendarIcon"] withColor:color];
    cell.roleView.backgroundColor = [UIColor colorWithRed:0 green:0.361 blue:0.588 alpha:1];
    cell.roleImageView.image = [ActionManager colorImage:[UIImage imageNamed:@"DriverIcon"] withColor:color];
    cell.timeLabel.textColor = color;
    cell.dateLabel.textColor = color;
    cell.seatsLabel.textColor = [UIColor whiteColor];
    cell.directionsLabel.textColor = color;

    return cell;
}

- (void)awakeFromNib {
}

-(void)setFrame:(CGRect)frame {
    frame.origin.x += 10;
    frame.size.width -= 2 * 10;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
