//
//  SerchItemCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchItemCell : UITableViewCell <UITextFieldDelegate>

+(SearchItemCell *)searchItemCell;

@property (nonatomic, assign) NSInteger index;
@property (weak, nonatomic) IBOutlet UIImageView *searchItemImageView;
@property (weak, nonatomic) IBOutlet UITextField *searchItemTextField;

@end
