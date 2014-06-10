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
    cell.backgroundColor = [UIColor customLightGray];
    cell.contentView.backgroundColor = [UIColor customLightGray];
    
    return cell;
}

- (IBAction)contactDriverButtonPressed:(id)sender {
    [self.delegate secondButtonPressed];
}

- (IBAction)joinRideButtonPressed:(id)sender {
    [self.delegate firstButtonPressed];
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
    [self.joinRideButton setBackgroundImage:[UIImage imageNamed:@"BlueButton"] forState:UIControlStateNormal];
    [self.joinRideButton setBackgroundImage:[UIImage imageNamed:@"BlueButton"] forState:UIControlStateHighlighted];

    [self.contactDriverButton setBackgroundImage:[UIImage imageNamed:@"BlueButton"] forState:UIControlStateNormal];
    [self.contactDriverButton setBackgroundImage:[UIImage imageNamed:@"BlueButton"] forState:UIControlStateHighlighted];
}

-(void)dealloc {
    self.delegate = nil;
}

@end
