//
//  StomtExperimentalCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 7/26/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stomt.h"

@protocol StomtExperimentalCellDelegate <NSObject>

-(void)shouldReloadTable;

@end

@interface StomtExperimentalCell : UITableViewCell

@property (nonatomic, strong) id<StomtExperimentalCellDelegate> delegate;

@property (strong, nonatomic) Stomt *stomt;
@property (nonatomic, assign) StomtOpinionType stomtOpinionType;

@property (weak, nonatomic) IBOutlet UITextView *stomTextView;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UILabel *counterLabel;

- (IBAction)plusButtonPressed:(id)sender;
- (IBAction)minusButtonPressed:(id)sender;

@end
