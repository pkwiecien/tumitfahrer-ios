//
//  DriverPassengerCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/16/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "DriverPassengerCell.h"

@implementation DriverPassengerCell


+(DriverPassengerCell *)driverPassengerCell {
    
    DriverPassengerCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DriverPassengerCell" owner:self options:nil] objectAtIndex:0];
    cell.backgroundColor = [UIColor customLightGray];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)awakeFromNib
{

}

@end
