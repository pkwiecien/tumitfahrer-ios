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
    
    EAIntroPage *page1 = [self introPageWithTitle:@"Need ride to the uni?" descriptionText:@"Search for a ride to your campus and join fellow students going to the uni by car. Travel in a nice student atmosphere." logo:[UIImage imageNamed:@"CampusIntroIcon"]];
    
    EAIntroPage *page2 = [self introPageWithTitle:@"Looking for weekend ideas?" descriptionText:@"Join activity rides and enjoy cool trip to IKEA, nearby lake or a hiking trip in the mountains." logo:[UIImage imageNamed:@"ActivityIntroIcon"]];
    
    EAIntroPage *page3 = [self introPageWithTitle:@"Have free seats in your car?" descriptionText:@"Create a ride and share travel expenses between all people." logo:[UIImage imageNamed:@"SeatsIntroIcon"]];
    
    EAIntroPage *page4 = [self introPageWithTitle:@"Don't have a car" descriptionText:@"Request a ride offer. Fellow students will pick you up. Enojoy the car ride" logo:[UIImage imageNamed:@"PassengerIntroIcon"]];
    
    EAIntroPage *page5 = [self introPageWithTitle:@"Be social" descriptionText:@"Stay informed about current rides via timeline. Let know your TUM friends about your rides via facebook" logo:[UIImage imageNamed:@"ShareIntroIcon"]];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:view.bounds andPages:@[page1, page2, page3, page4, page5]];
    
    return intro;
}

+(EAIntroPage *)introPageWithTitle:(NSString *)title descriptionText:(NSString *)descriptionText logo:(UIImage *)logo {
    EAIntroPage *page = [EAIntroPage page];
    page.title = title;
    page.titlePositionY = 220;
    page.titleIconView = [[UIImageView alloc] initWithImage:logo];
    page.titleIconPositionY = 100;
    page.descWidth = 250;
    page.desc = descriptionText;
    page.descPositionY = 200;
    page.titleIconPositionY = 100;
    page.bgImage = [UIImage imageNamed:@"bg1.jpg"];
    return page;
}


@end
