//
//  GeneralInfoCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/19/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeneralInfoCell : UITableViewCell

+ (GeneralInfoCell *)generalInfoCell;

@property (weak, nonatomic) IBOutlet UILabel *driverLabel;
@property (weak, nonatomic) IBOutlet UIImageView *driverImageView;

@property (weak, nonatomic) IBOutlet UILabel *passengerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *passengerImageView;

@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;

@end
