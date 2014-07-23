//
//  ControllerUtilities.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/15/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Ride;

/**
 *  Class with utilitie function for view controllers.
 */
@interface ControllerUtilities : NSObject

/**
 *  Returns a right type of ride detail view controller for a ride.
 *
 *  @param ride The Ride object.
 *
 *  @return View controller
 */
+(UIViewController *)viewControllerForRide:(Ride *)ride;

/**
 *  Prepares an intro view that can by displayed anywhere in a view controller.
 *
 *  @param view The current view.
 *
 *  @return UIView with intro pages.
 */
+(UIView *)prepareIntroForView:(UIView *)view;

@end
