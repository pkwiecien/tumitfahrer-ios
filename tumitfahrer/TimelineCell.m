//
//  TimelineCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/10/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "TimelineCell.h"
#import "ActionManager.h"

@implementation TimelineCell

+ (TimelineCell *)timelineCell {
    
    TimelineCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TimelineCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.backgroundImageView.image = [ActionManager imageWithColor:[UIColor darkestBlue]];

    return cell;
}

@end
