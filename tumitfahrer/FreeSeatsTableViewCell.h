//
//  FreeSeatsTableViewCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/23/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreeSeatsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *stepperLabelText;
@property (weak, nonatomic) IBOutlet UILabel *passengersCountLabel;
- (IBAction)stepperValueChanged:(UIStepper *)sender;

@end
