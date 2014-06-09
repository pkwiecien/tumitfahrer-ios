//
//  SerchItemCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "SliderCell.h"

@implementation SliderCell

+(SliderCell *)sliderCell {
    
    SliderCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SliderCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dividerView.backgroundColor = [UIColor customLightGray];
    return cell;
}

-(void)awakeFromNib {

}

- (IBAction)sliderChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    NSInteger val = lroundf(slider.value);
    self.selectedDistanceLabel.text = [NSString stringWithFormat:@"%d km",val];
    [self.delegate sliderChangedToValue:val indexPath:self.indexPath];
}

@end
