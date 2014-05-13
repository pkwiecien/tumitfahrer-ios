//
//  RidesCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RidesCell : UITableViewCell

+(RidesCell *)ridesCell;

@property (weak, nonatomic) IBOutlet UIImageView *rideImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *directionsLabel;

@end
