//
//  NavigationBarUtilities.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/4/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NavigationBarUtilities : NSObject

+ (UIView *)makeBackground:(UIView*)view;
+ (void)setupNavbar:(UINavigationController**)navigationController;
+ (void)setupNavbar:(UINavigationController **)navigationController withColor:(UIColor *)color;

@end
