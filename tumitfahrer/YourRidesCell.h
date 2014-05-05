//
//  YourRidesCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/4/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YourRidesCell : UITableViewCell

+ (YourRidesCell*)yourRidesCell;

@property (weak, nonatomic) IBOutlet UIImageView *rideImage;
@property (weak, nonatomic) IBOutlet UILabel *departurePlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureTimeLabel;

@end
