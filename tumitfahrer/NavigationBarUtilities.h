//
//  NavigationBarUtilities.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/4/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Class that sets up a navigation bar with a given color.
 */
@interface NavigationBarUtilities : NSObject

/**
 *  Sets up navigation bar for the given color.
 *
 *  @param navigationController Navigation controller object which should contain the navigation bar.
 *  @param color                Requested color of the navigation bar.
 */
+ (void)setupNavbar:(UINavigationController **)navigationController withColor:(UIColor *)color;

@end
