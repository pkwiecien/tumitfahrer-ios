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
    
    cell.rideImage.layer.cornerRadius = 4.0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.layer.borderWidth = 1.0f;
    cell.backgroundColor = [UIColor clearColor];
    cell.layer.backgroundColor = [UIColor whiteColor].CGColor;
    // performance improvement
    cell.layer.masksToBounds = NO;

    return cell;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(void)setFrame:(CGRect)frame {
    frame.origin.x += 20;
    frame.size.width -= 2 * 20;
    [super setFrame:frame];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
