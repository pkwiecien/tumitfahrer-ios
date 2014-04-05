//
//  AnotherActivitiesViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/4/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SlideNavigationController.h>

@interface AnotherActivitiesViewController : UIViewController <SlideNavigationControllerDelegate, UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

- (IBAction)addIconPressed:(id)sender;

@end
