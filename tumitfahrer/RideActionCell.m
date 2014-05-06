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
    UIColor *iOSgreenColor = [UIColor colorWithRed:0.298 green:0.851 blue:0.392 alpha:1];
    [self.joinRideButton setBackgroundImage:[ActionManager colorImage:[UIImage imageNamed:@"GreenButtonEmpty"] withColor:iOSgreenColor] forState:UIControlStateNormal];
    [self.joinRideButton setBackgroundImage:[ActionManager colorImage:[UIImage imageNamed:@"RoundedBox"] withColor:iOSgreenColor] forState:UIControlStateHighlighted];

    [self.contactDriverButton setBackgroundImage:[ActionManager colorImage:[UIImage imageNamed:@"GreenButtonEmpty"] withColor:[UIColor orangeColor]] forState:UIControlStateNormal];
    [self.contactDriverButton setBackgroundImage:[ActionManager colorImage:[UIImage imageNamed:@"RoundedBox"] withColor:[UIColor orangeColor]] forState:UIControlStateHighlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}


@end
