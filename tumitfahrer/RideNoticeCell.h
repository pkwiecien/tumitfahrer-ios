//
//  RideNoticeCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/6/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RideNoticeCell : UITableViewCell

+ (RideNoticeCell *)rideNoticeCell;

@property (weak, nonatomic) IBOutlet UIImageView *noticeImage;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;

@end
