//
//  RidePersonCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/14/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RidePersonCellDelegate <NSObject>

-(void)leftButtonPressedWithObject:(id)object cellType:(CellTypeEnum)cellType;
-(void)rightButtonPressedWithObject:(id)object cellType:(CellTypeEnum)cellType;

@end

@interface RidePersonCell : UITableViewCell

+ (RidePersonCell*)ridePersonCell;

@property (nonatomic, strong) id<RidePersonCellDelegate> delegate;
@property id leftObject;
@property id rightObject;

@property (assign, nonatomic) CellTypeEnum cellTypeEnum;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *personImageView;

- (IBAction)rightButtonPressed:(id)sender;
- (IBAction)leftButtonPressed:(id)sender;

@end
