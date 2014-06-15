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
#import "EAIntroView.h"
#import "ActionManager.h"

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

+(UIView *)prepareIntroForView:(UIView *)view {
    // first intro page
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.titlePositionY = 220;
    page1.desc = @"this is sampe description";
    page1.descPositionY = 200;
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CircleBlue"]];
    page1.titleIconPositionY = 100;
    page1.bgImage = [ActionManager imageWithColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"TweedPattern"]]];
    
    // second intro page
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.titlePositionY = 220;
    page2.desc = @"this is sampel description";
    page2.descPositionY = 200;
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CircleBlue"]];
    page2.titleIconPositionY = 100;
    page2.bgImage = [ActionManager imageWithColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"TweedPattern"]]];
    
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:view.bounds andPages:@[page1, page2]];
    return intro;
}


@end
