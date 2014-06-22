//
//  ButtonCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "ButtonCell.h"
#import "ActionManager.h"

@implementation ButtonCell

+(ButtonCell *)buttonCell {
    ButtonCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ButtonCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.cellButton setTitle:@"Search" forState:UIControlStateNormal];
    [cell.cellButton setBackgroundImage:[ActionManager colorImage:[UIImage imageNamed:@"BlueButton"] withColor:[UIColor lighterBlue]] forState:UIControlStateNormal];
    
    return cell;
}

- (IBAction)buttonPressed:(id)sender {
    [self.delegate buttonSelected];
}

-(void)dealloc {
    self.delegate = nil;
}

@end
