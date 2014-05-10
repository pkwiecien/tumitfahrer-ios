//
//  UIViewController+SideBarController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/10/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"

@interface UIViewController (SideBarController)

@property(nonatomic, strong, readonly) MMDrawerController *sideBarController;

@end
