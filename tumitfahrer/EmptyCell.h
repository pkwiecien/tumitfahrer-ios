//
//  EmptyCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/14/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyCell : UITableViewCell

+(EmptyCell *)emptyCell;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
