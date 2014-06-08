//
//  MessageListCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageListCell : UITableViewCell
+(MessageListCell *)messageListCell;

@property (weak, nonatomic) IBOutlet UILabel *passengerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMessageDateLabel;


@end
