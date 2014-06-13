//
//  DriverCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "DriverCell.h"

@implementation DriverCell

+ (DriverCell*)driverCell {
    
    DriverCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DriverCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor darkerBlue];
    cell.contentView.backgroundColor = [UIColor darkerBlue];
    
    return cell;
}


@end
