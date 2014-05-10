//
//  TimelineCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/10/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "TimelineCell.h"
#import "ActionManager.h"

@implementation TimelineCell

+(TimelineCell *)timelineCell {
    
    TimelineCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TimelineCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib
{
    self.backgroundImageView.image = [ActionManager imageWithColor:[UIColor greenColor]];
    self.iconImageView.image = [UIImage imageNamed:@"FilterIcon"];
    
    // activity description label
    self.activityDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 250, 60)];
    self.activityDescriptionLabel.text = @"Pawel has just added a ride from Kieferngarten to Forschungszentrum";
    self.activityDescriptionLabel.numberOfLines = 0;
    [self.activityDescriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [self.activityDescriptionLabel sizeToFit];
    [self addSubview:self.activityDescriptionLabel];
    
    self.activityDetailLabel.text = @"6 minutes ago";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
