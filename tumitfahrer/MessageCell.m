//
//  MessageCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/4/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell


+(MessageCell *)messageCell {
    
    MessageCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(void)setFrame:(CGRect)frame {
    frame.origin.x += 30;
    frame.size.width -= 2 * 30;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
