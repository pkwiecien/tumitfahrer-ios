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
- (IBAction)addIconPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@end
