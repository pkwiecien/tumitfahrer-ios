//
//  JoinDriverCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/10/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "JoinDriverCell.h"

@implementation JoinDriverCell


+(JoinDriverCell *)joinDriverCell {
    
    JoinDriverCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"JoinDriverCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor customLightGray];
    
    return cell;
}

- (IBAction)joinButtonPressed:(id)sender {
    [self.delegate joinJoinDriverCellButtonPressed];
}

- (IBAction)contactButtonPressed:(id)sender {
    [self.delegate contactJoinDriverCellButtonPressed];
}

@end
