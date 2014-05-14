//
//  NavigationBarUtilities.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/4/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "NavigationBarUtilities.h"
#import "ActionManager.h"

@implementation NavigationBarUtilities

+(UIView *)makeBackground:(UIView*)view {
    UIImageView *imgBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gradientBackground"]];
    imgBackgroundView.frame = view.bounds;
    [view addSubview:imgBackgroundView];
    [view sendSubviewToBack:imgBackgroundView];
    return view;
}

// navigation controller is sent by reference
+(void)setupNavbar:(UINavigationController**)navigationController {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    double width = (*navigationController).navigationBar.frame.size.width;
    double height = (*navigationController).navigationBar.frame.size.height;
    
    UIImage *croppedImage = [ActionManager cropImage:[UIImage imageNamed:@"gradientBackground"] newRect:CGRectMake(0, 0, width, height)];
    [(*navigationController).navigationBar setBackgroundImage:croppedImage forBarMetrics:UIBarMetricsDefault];
    (*navigationController).navigationBar.shadowImage = [UIImage new];
    (*navigationController).navigationBar.translucent = NO;
    (*navigationController).navigationBarHidden = NO;
    
    (*navigationController).navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

+(void)setupNavbar:(UINavigationController **)navigationController withColor:(UIColor *)color{
    [(*navigationController).navigationBar setBarTintColor:color];
    (*navigationController).navigationBar.tintColor = [UIColor whiteColor];
    (*navigationController).navigationBar.translucent = NO;
    (*navigationController).navigationBarHidden = NO;
    (*navigationController).navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

@end
