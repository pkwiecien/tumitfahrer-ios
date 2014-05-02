//
//  DetailsMessagesChoiceCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "DetailsMessagesChoiceCell.h"

@implementation DetailsMessagesChoiceCell

+(DetailsMessagesChoiceCell *)detailsMessagesChoiceCell {
    
    DetailsMessagesChoiceCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailsMessagesChoiceCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}
@end
