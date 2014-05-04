//
//  DetailsMessagesChoiceCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RideActionCell.h"
#import "ActionManager.h"

@implementation RideActionCell

+(RideActionCell *)detailsMessagesChoiceCell {
    
    RideActionCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"RideActionCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (IBAction)contactDriverButtonPressed:(id)sender {
    [self.delegate contactDriverButtonPressed];
}

- (IBAction)joinRideButtonPressed:(id)sender {
    [self.delegate joinRideButtonPressed];
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
    [self.contactDriverButton setBackgroundImage:[ActionManager colorImage:[UIImage imageNamed:@"RoundedBox"] withColor:[UIColor greenColor]] forState:UIControlStateNormal];
    [self.joinRideButton setBackgroundImage:[ActionManager colorImage:[UIImage imageNamed:@"RoundedBox"] withColor:[UIColor orangeColor]] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}
@end