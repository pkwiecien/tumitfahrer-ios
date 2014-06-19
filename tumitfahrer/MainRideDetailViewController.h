//
//  MainRideDetailViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/14/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeaderContentView, Ride;

@interface MainRideDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate> {
    @protected UIButton *editButton;
}

@property (nonatomic, strong) HeaderContentView *rideDetail;
@property (nonatomic, assign) ShouldDisplayEnum displayEnum;
@property (nonatomic, assign) ShouldGoBackEnum shouldGoBackEnum;
@property (strong, nonatomic) NSArray *headerTitles;
@property (strong, nonatomic) NSArray *headerIcons;
@property (nonatomic, strong) Ride* ride;

@property (nonatomic, strong) UILabel *counterLabel;
@property (nonatomic, strong) UITextView *textView;

- (void)showCancelationAlertView;

@end
