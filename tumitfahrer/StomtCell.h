//
//  StomtCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 7/23/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StomtCell : UITableViewCell

+ (StomtCell *)stomtCell;

@property (weak, nonatomic) IBOutlet UITextView *stomtTextView;

@end
