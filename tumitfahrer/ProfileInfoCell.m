//
//  ProfileInfoCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/19/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "ProfileInfoCell.h"

@implementation ProfileInfoCell

+(ProfileInfoCell *)profileInfoCell {
    
    ProfileInfoCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"ProfileInfoCell" owner:self options:nil] objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor customLightGray];
    cell.contentView.backgroundColor = [UIColor customLightGray];
    
    return cell;
}


- (void)awakeFromNib
{
    // Initialization code
}

@end
