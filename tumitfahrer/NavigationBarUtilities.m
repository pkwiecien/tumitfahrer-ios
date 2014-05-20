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

+(void)setupNavbar:(UINavigationController **)navigationController withColor:(UIColor *)color{
    [(*navigationController).navigationBar setBarTintColor:color];
    (*navigationController).navigationBar.tintColor = [UIColor whiteColor];
    (*navigationController).navigationBar.translucent = NO;
    (*navigationController).navigationBarHidden = NO;
    (*navigationController).navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

@end
