//
//  YourRidesPageViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/6/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LogoView;

@protocol YourRidesPageViewControllerDelegate

-(void)pastRidesLoaded:(NSArray *)rides;

@end


@interface YourRidesPageViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;
@property (nonatomic, weak) id<YourRidesPageViewControllerDelegate> delegate;

@property (nonatomic, retain) LogoView *logo;

@end
