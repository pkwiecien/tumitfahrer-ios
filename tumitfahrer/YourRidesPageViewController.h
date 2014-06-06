//
//  YourRidesPageViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/6/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LogoView;

@interface YourRidesPageViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;

@property (nonatomic, retain) LogoView *logo;

@end
