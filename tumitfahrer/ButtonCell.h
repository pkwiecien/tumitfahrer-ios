//
//  ButtonCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ButtonCellDelegate

-(void)buttonSelected;

@end

@interface ButtonCell : UITableViewCell

+(ButtonCell *)buttonCell;
@property (weak, nonatomic) IBOutlet UIButton *cellButton;
@property (nonatomic, strong) id <ButtonCellDelegate> delegate;
- (IBAction)buttonPressed:(id)sender;

@end
