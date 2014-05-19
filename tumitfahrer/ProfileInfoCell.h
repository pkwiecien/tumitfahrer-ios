//
//  ProfileInfoCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/19/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileInfoCell : UITableViewCell

+(ProfileInfoCell *)profileInfoCell;

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellDescription;

@end
