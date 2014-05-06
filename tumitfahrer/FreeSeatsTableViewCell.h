//
//  FreeSeatsTableViewCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/23/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FreeSeatsCellDelegate <NSObject>

- (void)stepperValueChanged:(NSInteger)stepperValue;

@end

@interface FreeSeatsTableViewCell : UITableViewCell

+(FreeSeatsTableViewCell *)freeSeatsTableViewCell;

@property (weak, nonatomic) IBOutlet UILabel *stepperLabelText;
@property (weak, nonatomic) IBOutlet UILabel *passengersCountLabel;
@property (nonatomic, strong) id<FreeSeatsCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIStepper *stepper;
- (IBAction)stepperValueChanged:(UIStepper *)sender;

@end
