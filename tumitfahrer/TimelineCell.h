//
//  TimelineCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/10/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineCell : UITableViewCell

+(TimelineCell *)timelineCell;

@property (retain, nonatomic) UILabel *activityDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityDetailLabel;

@end
