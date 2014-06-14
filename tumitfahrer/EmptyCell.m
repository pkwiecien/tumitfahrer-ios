//
//  EmptyCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/14/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "EmptyCell.h"

@implementation EmptyCell

+(EmptyCell *)emptyCell {
    EmptyCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"EmptyCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor customLightGray];
    
    return cell;
}

@end
