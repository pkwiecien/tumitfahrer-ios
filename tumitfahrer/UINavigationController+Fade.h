//
//  UINavigationController+Fade.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/4/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Categoy that add a new animated effect of pushing and poping a view controller.
 */
@interface UINavigationController (Fade)

- (void)pushViewControllerWithFade:(UIViewController *)viewController;
- (UIViewController *)popViewControllerWithFade;

@end
