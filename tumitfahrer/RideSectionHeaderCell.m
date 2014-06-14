//
//  RideNoticeCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/6/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RideSectionHeaderCell.h"
#import "ActionManager.h"

@implementation RideSectionHeaderCell

+ (RideSectionHeaderCell *)rideSectionHeaderCell {
    
    RideSectionHeaderCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"RideSectionHeaderCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor darkerBlue];
    cell.contentView.backgroundColor = [UIColor darkerBlue];
    cell.noticeImage.image = [UIImage imageNamed:@"DriverIcon"];
    
    return cell;
}



@end
