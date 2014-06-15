//
//  ControllerUtilities.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/15/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "ControllerUtilities.h"
#import "RequestViewController.h"
#import "OfferViewController.h"
#import "OwnerOfferViewController.h"
#import "OwnerRequestViewController.h"
#import "Ride.h"
#import "User.h"
#import "CurrentUser.h"

@implementation ControllerUtilities

+(UIViewController *)viewControllerForRide:(Ride *)ride {
    if (![ride.rideOwner.userId isEqualToNumber:[CurrentUser sharedInstance].user.userId] && [ride.isRideRequest boolValue]) {
        RequestViewController *requestVC = [[RequestViewController alloc] init];
        requestVC.ride = ride;
        return requestVC;
    } else if(![ride.rideOwner.userId isEqualToNumber:[CurrentUser sharedInstance].user.userId] && ![ride.isRideRequest boolValue]) {
        OfferViewController *offerVc = [[OfferViewController alloc] init];
        offerVc.ride = ride;
        return offerVc;
    } else if([ride.rideOwner.userId isEqualToNumber:[CurrentUser sharedInstance].user.userId] && ![ride.isRideRequest boolValue]) {
        OwnerOfferViewController *ownerOfferVc = [[OwnerOfferViewController alloc] init];
        ownerOfferVc.ride = ride;
        return ownerOfferVc;
    } else {
        OwnerRequestViewController *ownerRequestVc = [[OwnerRequestViewController alloc] init];
        ownerRequestVc.ride = ride;
        return ownerRequestVc;
    }
}


@end
