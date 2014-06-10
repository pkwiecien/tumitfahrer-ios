//
//  YourRidesCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/4/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "YourRidesCell.h"

@implementation YourRidesCell

+(YourRidesCell *)yourRidesCell {
    
    YourRidesCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"YourRidesCell" owner:self options:nil] objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];

    return cell;
}

@end
