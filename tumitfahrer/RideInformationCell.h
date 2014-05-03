//
//  RideInformationCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RideInformationCell : UITableViewCell

+ (RideInformationCell*) rideInformationCell;

@property (weak, nonatomic) IBOutlet UILabel *departurePlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end
