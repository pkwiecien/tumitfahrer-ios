//
//  SerchItemCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SliderCellDelegate

-(void)sliderChangedToValue:(NSInteger)value indexPath:(NSIndexPath*)indexPath;

@end

@interface SliderCell : UITableViewCell

+(SliderCell *)sliderCell;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIView *dividerView;
@property (weak, nonatomic) IBOutlet UILabel *selectedDistanceLabel;
#ifdef DEBUG
@property (weak, nonatomic) IBOutlet UISlider *slider;
#endif
@property (nonatomic, strong) id <SliderCellDelegate> delegate;

@end
