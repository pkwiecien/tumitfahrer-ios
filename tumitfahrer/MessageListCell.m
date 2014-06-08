//
//  MessageListCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "MessageListCell.h"

@implementation MessageListCell

+(MessageListCell *)messageListCell {
    MessageListCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageListCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
