//
//  DriverPassengerCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/16/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SementedControlCellDelegate

-(void)segmentedControlChangedToIndex:(NSInteger)index segmentedControlId:(NSInteger)controlId;

@end

@interface SegmentedControlCell : UITableViewCell

+(SegmentedControlCell *)segmentedControlCell;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) id <SementedControlCellDelegate> delegate;
@property (nonatomic, strong) NSString *firstSegmentTitle;
@property (nonatomic, strong) NSString *secondSegmentTitle;
@property (nonatomic, assign) NSInteger controlId;

-(void)setFirstSegmentTitle:(NSString *)firstSegmentTitle secondSementTitle:(NSString *)secondSegmentTitle;
-(void)addHandlerToSegmentedControl;

@end
