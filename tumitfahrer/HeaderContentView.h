//
//  RideDetailView.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderImageView.h"
#import "Ride.h"

@protocol HeaderContentViewDelegate

@optional

- (void)headerViewTapped;
- (void)mapButtonTapped;
- (void)editButtonTapped;
- (void)initFields;

@end

@interface HeaderContentView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) id<HeaderContentViewDelegate> delegate;

@property (nonatomic) CGFloat defaultimagePagerHeight;
@property (nonatomic) CGFloat parallaxScrollFactor;

@property (nonatomic) CGFloat headerFade;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIColor *backgroundViewColor;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) HeaderImageView *rideDetailHeaderView;
@property (nonatomic) CGRect rideDetailFrame;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) id<UITableViewDataSource> tableViewDataSource;
@property (nonatomic, weak) id<UITableViewDelegate> tableViewDelegate;

@property (nonatomic, strong) NSData *selectedImageData;
@property (nonatomic, strong) UIImage *circularImage;

@property (nonatomic, assign) BOOL shouldDisplayGradient;

@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UILabel *departureLabel;
@property (nonatomic, strong) UILabel *destinationLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *calendarLabel;

@end
