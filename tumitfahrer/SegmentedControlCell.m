//
//  DriverPassengerCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/16/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "SegmentedControlCell.h"

@implementation SegmentedControlCell

+(SegmentedControlCell *)segmentedControlCell {
    
    SegmentedControlCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SegmentedControlCell" owner:self options:nil] objectAtIndex:0];
    cell.backgroundColor = [UIColor customLightGray];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.segmentedControl.selectedSegmentIndex = 0;
    
    return cell;
}

-(void)setFirstSegmentTitle:(NSString *)firstSegmentTitle secondSementTitle:(NSString *)secondSegmentTitle {
    [self.segmentedControl setTitle:firstSegmentTitle forSegmentAtIndex:0];
    [self.segmentedControl setTitle:secondSegmentTitle forSegmentAtIndex:1];
}

-(void)addHandlerToSegmentedControl {
    [self.segmentedControl addTarget:self action:@selector(pickOne:) forControlEvents:UIControlEventValueChanged];
}

-(void) pickOne:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    [self.delegate segmentedControlChangedToIndex:segmentedControl.selectedSegmentIndex segmentedControlId:self.controlId];
}

-(void)dealloc {
    self.delegate = nil;
}

@end
