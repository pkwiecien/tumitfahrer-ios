//
//  ControllerUtilities.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/15/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Ride;

@interface ControllerUtilities : NSObject

+(UIViewController *)viewControllerForRide:(Ride *)ride;
+(UIView *)prepareIntroForView:(UIView *)view;

@end
