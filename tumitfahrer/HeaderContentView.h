//
//  RideDetailView.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderImageView.h"

@interface HeaderContentView : UIView <UIScrollViewDelegate>

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

@end
