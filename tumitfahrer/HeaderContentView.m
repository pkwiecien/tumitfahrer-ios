//
//  RideDetailView.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "HeaderContentView.h"

@implementation HeaderContentView {
    UITapGestureRecognizer *singleTapGestureRecognizer;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.defaultimagePagerHeight = 180.0f;
    self.parallaxScrollFactor = 0.6f;
    self.headerFade = 130.0f;
    self.backgroundViewColor = [UIColor clearColor];
    self.shouldDisplayGradient = NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        if (iPhone5) {
            self.tableView.frame = CGRectMake(0, 0, 320, 568);
        } else {
            self.tableView.frame = CGRectMake(0, 0, 320, 460);
        }
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self.tableViewDelegate;
        self.tableView.dataSource = self.tableViewDataSource;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // Add scroll view KVO
        void *context = (__bridge void *)self;
        [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:context];
        [self addSubview:self.tableView];
    }
    
    if (!self.tableView.tableHeaderView) {
        UIView *tableHeaderView = nil;
        if (self.shouldDisplayGradient) {
            tableHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"HeaderLabelsView" owner:self options:nil] objectAtIndex:0];;
            self.refreshButton = (UIButton *)[tableHeaderView viewWithTag:16];
            self.departureLabel = (UILabel *)[tableHeaderView viewWithTag:10];
            self.destinationLabel = (UILabel *)[tableHeaderView viewWithTag:11];
            self.calendarLabel = (UILabel *)[tableHeaderView viewWithTag:12];
            self.timeLabel = (UILabel *)[tableHeaderView viewWithTag:13];
            [self.delegate initFields];
        } else {
            CGRect tableHeaderViewFrame = CGRectMake(0.0, 0.0, self.tableView.frame.size.width, self.defaultimagePagerHeight);
            tableHeaderView = [[UIView alloc] initWithFrame:tableHeaderViewFrame];
        }
        tableHeaderView.backgroundColor = [UIColor clearColor];

        singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewTapped)];
        [singleTapGestureRecognizer setNumberOfTapsRequired:1];

        [tableHeaderView addGestureRecognizer:singleTapGestureRecognizer];
        
        self.tableView.tableHeaderView = tableHeaderView;
    }
    
    if(!self.rideDetailHeaderView){
        self.rideDetailFrame = CGRectMake(0.0f, -self.defaultimagePagerHeight * self.parallaxScrollFactor *2, self.tableView.frame.size.width, self.defaultimagePagerHeight + (self.defaultimagePagerHeight * self.parallaxScrollFactor * 4));
        self.rideDetailHeaderView = [[HeaderImageView alloc] initWithFrame:self.rideDetailFrame];
        if (self.circularImage != nil) {
            self.rideDetailHeaderView.circularImage  = self.circularImage;
        }
        self.rideDetailHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.rideDetailHeaderView.selectedImageData = self.selectedImageData;
        [self insertSubview:self.rideDetailHeaderView belowSubview:self.tableView];
    }
    
    // Add the background tableView
    if (!self.backgroundView) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.defaultimagePagerHeight,
                                                                self.tableView.frame.size.width,
                                                                self.tableView.frame.size.height - self.defaultimagePagerHeight)];
        view.backgroundColor = self.backgroundViewColor;
        self.backgroundView = view;
		self.backgroundView.userInteractionEnabled=NO;
        [self.tableView insertSubview:self.backgroundView atIndex:0];
    }
}

- (void)setTableViewDataSource:(id<UITableViewDataSource>)tableViewDataSource
{
    _tableViewDataSource = tableViewDataSource;
    self.tableView.dataSource = _tableViewDataSource;
    
    if (_tableViewDelegate) {
        [self.tableView reloadData];
    }
}

- (void)setTableViewDelegate:(id<UITableViewDelegate>)tableViewDelegate
{
    _tableViewDelegate = tableViewDelegate;
    self.tableView.delegate = _tableViewDelegate;
    
    if (_tableViewDataSource) {
        [self.tableView reloadData];
    }
}

- (void)setHeaderView:(UIView *)headerView
{
    _headerView = headerView;
}

#pragma mark - KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	// Make sure we are observing this value.
	if (context != (__bridge void *)self) {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
		return;
	}
    
    if ((object == self.tableView) &&
        ([keyPath isEqualToString:@"contentOffset"] == YES)) {
        [self scrollViewDidScrollWithOffset:self.tableView.contentOffset.y];
        return;
    }
}

- (void)scrollViewDidScrollWithOffset:(CGFloat)scrollOffset
{
    CGFloat junkViewFrameYAdjustment = 0.0;
    
    // If the user is pulling down
    if (scrollOffset < 0) {
        junkViewFrameYAdjustment = self.rideDetailFrame.origin.y - (scrollOffset * self.parallaxScrollFactor);
    }
    
    // If the user is scrolling normally,
    else {
        junkViewFrameYAdjustment = self.rideDetailFrame.origin.y - (scrollOffset * self.parallaxScrollFactor);
        
        // Don't move the map way off-screen
        if (junkViewFrameYAdjustment <= -(self.rideDetailFrame.size.height)) {
            junkViewFrameYAdjustment = -(self.rideDetailFrame.size.height);
        }
        
    }
    
    if(scrollOffset > _headerFade && _headerView.alpha == 0.0){ //make the header appear
        _headerView.alpha = 0;
        _headerView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _headerView.alpha = 1;
        }];
    }
    else if(scrollOffset < _headerFade && _headerView.alpha == 1.0){ //make the header disappear
        [UIView animateWithDuration:0.3 animations:^{
            _headerView.alpha = 0;
        } completion: ^(BOOL finished) {
            _headerView.hidden = YES;
        }];
    }
    
    if (junkViewFrameYAdjustment) {
        CGRect newJunkViewFrame = self.rideDetailHeaderView.frame;
        newJunkViewFrame.origin.y = junkViewFrameYAdjustment;
        self.rideDetailHeaderView.frame = newJunkViewFrame;
    }
}

-(void)headerViewTapped {
    [self.delegate headerViewTapped];
}

-(void)mapButtonPressed {
    [self.delegate mapButtonTapped];
}

-(void)editButtonPressed {
    [self.delegate editButtonTapped];
}

- (void)dealloc {
    [self.tableView.tableHeaderView removeGestureRecognizer:singleTapGestureRecognizer];
	[self.tableView removeObserver:self forKeyPath:@"contentOffset"];
    self.delegate = nil;
}

@end
