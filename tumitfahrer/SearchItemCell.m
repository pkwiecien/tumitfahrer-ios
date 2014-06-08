//
//  SerchItemCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "SearchItemCell.h"

@implementation SearchItemCell

+(SearchItemCell *)searchItemCell {
    
    SearchItemCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchItemCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)awakeFromNib {
    self.searchItemTextField.delegate = self;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

@end
