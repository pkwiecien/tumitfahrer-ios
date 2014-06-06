//
//  UINavigationController+Fade.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/4/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "UINavigationController+Fade.h"

@implementation UINavigationController (Fade)

- (void)pushViewControllerWithFade:(UIViewController *)viewController {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self pushViewController:viewController animated:NO];
}

-(UIViewController *)popViewControllerWithFade {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    [self.view.layer addAnimation:transition forKey:kCATransition];
    return [self popViewControllerAnimated:NO];
}

@end
