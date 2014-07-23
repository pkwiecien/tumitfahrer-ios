//
//  StomtCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 7/23/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "StomtCell.h"

@implementation StomtCell

+ (StomtCell *)stomtCell {
    
    StomtCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"StomtCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    return cell;
}


@end
