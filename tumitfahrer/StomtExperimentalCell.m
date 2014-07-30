//
//  StomtExperimentalCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 7/26/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "StomtExperimentalCell.h"
#import "ActionManager.h"
#import "StomtUtilities.h"

@implementation StomtExperimentalCell

- (void)awakeFromNib {
    self.plusButton.backgroundColor = [UIColor customGreen];
    [self.plusButton addTarget:self action:@selector(plusHighlight) forControlEvents:UIControlEventTouchDown|UIControlEventTouchUpOutside|UIControlEventTouchCancel];

    self.minusButton.backgroundColor = [UIColor lightRed];
    [self.minusButton addTarget:self action:@selector(minusHighlight) forControlEvents:UIControlEventTouchDown|UIControlEventTouchUpOutside|UIControlEventTouchCancel];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)plusHighlight {
    self.plusButton.backgroundColor = [UIColor greenColor];
}

-(void)plusNormal {
    self.plusButton.backgroundColor = [UIColor customGreen];
}

-(void)minusHighlight {
    self.minusButton.backgroundColor = [UIColor redColor];
}

-(void)minusNormal {
    self.minusButton.backgroundColor = [UIColor lightRed];
}

- (IBAction)plusButtonPressed:(id)sender {
    if (self.stomtOpinionType == NoneStomt) {
        [StomtUtilities postAgreementWithId:self.stomt.stomtId isNegative:[NSNumber numberWithInt:0] boolCompletionHandler:^(BOOL posted) {
            [self.delegate shouldReloadTable];
        }];
    } else if(self.stomtOpinionType == NegativeStomt) { // cancel negative stomt, delete user's agreement
        [StomtUtilities deleteAgreementFromStomt:self.stomt block:^(BOOL posted) {
            self.minusButton.backgroundColor = [UIColor lightGrayColor];
            self.plusButton.backgroundColor = [UIColor lightGrayColor];
            [self.delegate shouldReloadTable];
        }];
    } else {
        self.plusButton.backgroundColor = [UIColor customGreen];
    }
}

- (IBAction)minusButtonPressed:(id)sender {
    if (self.stomtOpinionType == NoneStomt) {
        [StomtUtilities postAgreementWithId:self.stomt.stomtId isNegative:[NSNumber numberWithInt:1] boolCompletionHandler:^(BOOL posted) {
            [self.delegate shouldReloadTable];
        }];
    } else if(self.stomtOpinionType == PositiveStomt) { // cancel positive stomt, delete user's agreement
        [StomtUtilities deleteAgreementFromStomt:self.stomt block:^(BOOL posted) {
            self.minusButton.backgroundColor = [UIColor lightGrayColor];
            self.plusButton.backgroundColor = [UIColor lightGrayColor];
            [self.delegate shouldReloadTable];
        }];
    } else {
        self.minusButton.backgroundColor = [UIColor lightRed];
    }
}

@end
