//
//  DetailsMessagesChoiceCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "DriverActionCell.h"
#import "ActionManager.h"

@implementation DriverActionCell

+(DriverActionCell *)driverActionCell {
    
    DriverActionCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"DriverActionCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor customLightGray];
    cell.contentView.backgroundColor = [UIColor customLightGray];
    
    return cell;
}

- (IBAction)contactButtonPressed:(id)sender {
    [self.delegate contactDriverActionCellButtonPressed];
}

- (IBAction)peopleButtonPressed:(id)sender {
    [self.delegate peopleDriverActionCellButtonPressed];
}

- (IBAction)deleteButtonPressed:(id)sender {
    [self.delegate deleteDriverActionCellButtonPressed];
}

- (IBAction)editButtonPressed:(id)sender {
    [self.delegate editDriverActionCellButtonPressed];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
//    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BlueButton"] forState:UIControlStateNormal];
//    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BlueButton"] forState:UIControlStateHighlighted];
//
//    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"BlueButton"] forState:UIControlStateNormal];
//    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"BlueButton"] forState:UIControlStateHighlighted];
}

-(void)dealloc {
    self.delegate = nil;
}

@end
