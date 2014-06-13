//
//  RequestorCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/13/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RequestorCell.h"
#import "WebserviceRequest.h"
#import "CurrentUser.h"

@implementation RequestorCell


+(RequestorCell *)requestorCell {
    RequestorCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"RequestorCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)layoutSubviews {
    self.requestorName.text = self.user.firstName;
}

- (IBAction)acceptRequestorButtonPressed:(id)sender {
    [WebserviceRequest acceptRideRequest:self.request isConfirmed:YES block:^(BOOL isAccepted) {
        if (isAccepted) {
            [self.delegate moveRequestorToPassengersFromIndexPath:self.indexPath requestor:self.user];
        } else {
            NSLog(@"could not be accepted");
        }
    }];
}

- (IBAction)declineRequestorButtonPressed:(id)sender {
    
    [WebserviceRequest acceptRideRequest:self.request isConfirmed:NO block:^(BOOL isAccepted) {
        if (isAccepted) {
            [self.delegate removeRideRequest:self.indexPath requestor:self.user];
        } else {
            NSLog(@"could not be accepted");
        }
    }];
}

@end
