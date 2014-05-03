//
//  PassengersCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "PassengersCell.h"
#import "ActionManager.h"

@implementation PassengersCell

+(PassengersCell *)passengersCell {
    PassengersCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PassengersCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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

-(void)drawCirlesWithPassengersNumber:(NSInteger)passengers freeSeats:(NSInteger)freeSeats {
    int posX = 40;
    int posY = 40;
    int padding = 80;
    int i = 0;
    int type = 0;
    while (i++<freeSeats) {
        [self drawCircleAtPostX:posX posY:posY tag:i type:type];
        posX += padding;
        if(i == passengers)
            type = 1;
        if (i % 3 == 0) {
            posY += 80;
            posX = 40;
        }
    }
}

-(void)drawCircleAtPostX:(NSInteger)posX posY:(NSInteger)posY tag:(NSInteger)tag type:(NSInteger)type {
    UIButton *buttonWithImage = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonWithImage.frame = CGRectMake(posX, posY, 60, 60);
    UIImage *circleImage;
    if (type == 0) {
        circleImage = [ActionManager colorImage:[UIImage imageNamed:@"CircleBlue"] withColor:[UIColor blueColor]];
    } else {
        circleImage = [ActionManager colorImage:[UIImage imageNamed:@"CircleBlue"] withColor:[UIColor grayColor]];
    }
    [buttonWithImage setImage:circleImage forState:UIControlStateNormal];
    [buttonWithImage setTag:tag];
    [buttonWithImage addTarget:self action:@selector(passengerCellPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonWithImage];
    
}


- (void)passengerCellPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSLog(@"BUtton with tag %d", [button tag]);
}

@end
