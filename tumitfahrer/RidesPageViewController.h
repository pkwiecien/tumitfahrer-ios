//
//  RidesPageViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LogoView;

@interface RidesPageViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;

@property (nonatomic, retain) LogoView *logo;
@property (nonatomic, assign) ContentType RideType;

-(instancetype)initWithContentType:(ContentType)contentType;

@end
