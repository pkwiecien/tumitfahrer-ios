//
//  UINavigationController+Fade.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/4/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Fade)

- (void)pushViewControllerWithFade:(UIViewController *)viewController;
- (UIViewController *)popViewControllerWithFade;

@end
