//
//  RequestActionCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/10/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RequestorActionCell.h"

@implementation RequestorActionCell

+(RequestorActionCell *)requestorActionCell {
    
    RequestorActionCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"RequestorActionCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor customLightGray];
    
    return cell;
}

- (IBAction)editButtonPressed:(id)sender {
    [self.delegate editRequestorActionCellButtonPressed];
}

- (IBAction)deleteButtonPressed:(id)sender {
    [self.delegate deleteRequestorActionCellButtonPressed];
}

@end
