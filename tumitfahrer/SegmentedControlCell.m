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

- (void)awakeFromNib {
    [self.segmentedControl addTarget:self action:@selector(pickOne:) forControlEvents:UIControlEventValueChanged];
}

-(void) pickOne:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    [self.delegate segmentedControlChangedToIndex:segmentedControl.selectedSegmentIndex];
    self.segmentedControl.selectedSegmentIndex = segmentedControl.selectedSegmentIndex;
}

@end
