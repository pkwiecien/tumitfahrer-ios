//
//  DetailsMessagesChoiceCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsMessagesChoiceCell : UITableViewCell

+ (DetailsMessagesChoiceCell*) detailsMessagesChoiceCell;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)segmentedControlChanges:(id)sender;

@end
