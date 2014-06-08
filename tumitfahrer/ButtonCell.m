//
//  ButtonCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "ButtonCell.h"

@implementation ButtonCell

+(ButtonCell *)buttonCell {
    ButtonCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ButtonCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellButton.titleLabel.text = @"Search";
    
    return cell;
}

@end
