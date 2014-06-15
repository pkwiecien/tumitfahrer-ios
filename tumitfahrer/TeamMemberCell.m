//
//  TeamMemberCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/15/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "TeamMemberCell.h"

@implementation TeamMemberCell

+(TeamMemberCell *)teamMemberCell {
    
    TeamMemberCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"TeamMemberCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor customLightGray];
    cell.contentView.backgroundColor = [UIColor customLightGray];
    
    return cell;
}

@end
