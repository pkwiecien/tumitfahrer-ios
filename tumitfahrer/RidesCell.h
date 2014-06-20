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

@property (weak, nonatomic) IBOutlet UILabel *actionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rideImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *directionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *roleImageView;
@property (weak, nonatomic) IBOutlet UIView *roleView;
@property (weak, nonatomic) IBOutlet UIView *seatsView;
@property (weak, nonatomic) IBOutlet UILabel *seatsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *calendarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gradientImageView;

@end
