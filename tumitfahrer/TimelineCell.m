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

+ (TimelineCell *)timelineCell {
    
    TimelineCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TimelineCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.backgroundImageView.image = [ActionManager imageWithColor:[UIColor darkestBlue]];

    return cell;
}

-(void)awakeFromNib {
    
    // activity description label
    self.activityDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 250, 60)];
    self.activityDescriptionLabel.text = @"abc asd asddsa dsa asdadsasd asdasdads";
    self.activityDescriptionLabel.numberOfLines = 2;
    [self.activityDescriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [self.activityDescriptionLabel sizeToFit];
    [self addSubview:self.activityDescriptionLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
