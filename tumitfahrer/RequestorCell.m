//
//  RequestorCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/13/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RequestorCell.h"
#import "WebserviceRequest.h"

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
    [WebserviceRequest acceptRideRequestForUserId:self.user.userId rideId:self.rideId block:^(BOOL isAccepted) {
        if (isAccepted) {
            NSLog(@"is accepted");
            [self.delegate moveRequestorToPassengersFromIndexPath:self.indexPath requestor:self.user];
        } else {
            NSLog(@"could not be accepted");
        }
    }];
}

- (IBAction)declineRequestorButtonPressed:(id)sender {
    
}

@end
