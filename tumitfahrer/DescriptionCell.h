//
//  DescriptionCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/15/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DescriptionCell : UITableViewCell

+ (DescriptionCell *)descriptionCell;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
