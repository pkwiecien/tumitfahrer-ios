//
//  SwitchTableViewCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/23/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwitchTableViewCellDelegate

-(void)switchChangedToStatus:(BOOL)status switchId:(NSInteger)switchId;

@end

@interface SwitchTableViewCell : UITableViewCell

@property (nonatomic, strong) id <SwitchTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *switchCellTextLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchElement;
@property (nonatomic, assign) NSInteger switchId;

- (IBAction)switchChanged:(id)sender;

@end
