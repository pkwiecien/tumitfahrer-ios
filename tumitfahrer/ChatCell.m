//
//  ChatCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "ChatCell.h"

@interface ChatCell ()

@property (strong, nonatomic) ChatInput * chatInput;

@end

@implementation ChatCell

+ (ChatCell*)chatCell {
    
    ChatCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ChatCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)addChatInput {
    
    self.chatInput = [[ChatInput alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    self.chatInput.stopAutoClose = NO;
    self.chatInput.placeholderLabel.text = @"  Send A Message";
    self.chatInput.delegate = self;
    self.chatInput.backgroundColor = [UIColor colorWithWhite:1 alpha:0.825f];

    [self addSubview:self.chatInput];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
