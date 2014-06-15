//
//  DescriptionCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/15/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "DescriptionCell.h"

@implementation DescriptionCell

+(DescriptionCell *)descriptionCell {
    
    DescriptionCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DescriptionCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.textView.backgroundColor = [UIColor customLightGray];
    
    return cell;
}

@end
