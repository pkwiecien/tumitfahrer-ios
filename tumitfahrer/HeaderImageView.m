//
//  HeaderView.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//
#define kPageControlHeight  30
#define kOverlayWidth       50
#define kOverlayHeight      15

#import "HeaderImageView.h"
#import "Ride.h"
#import "CircularImageView.h"

@interface HeaderImageView () <UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    CGRect imageFrame;
}
@end

@implementation HeaderImageView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
}

- (void) layoutSubviews
{
    [self initialize];
}

#pragma mark - General
- (void) initialize
{
    self.clipsToBounds = YES;
    [self initializeScrollView];
    [self loadData];
}

- (void) reloadData
{
    for (UIView *view in _scrollView.subviews)
        [view removeFromSuperview];
    
    [self loadData];
}

#pragma mark - ScrollView Initialization
- (void) initializeScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = self.autoresizingMask;
    [self addSubview:_scrollView];
}

- (void) loadData
{
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width,
                                           _scrollView.frame.size.height)];
    
    imageFrame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
    [imageView setBackgroundColor:[UIColor clearColor]];
    [imageView setTag:0];
    [imageView setImage:[UIImage imageWithData:self.selectedImageData]];
    
    [_scrollView addSubview:imageView];
    if (self.circularImage != nil) {
        [self addCircularImage:self.circularImage];
    }
}

- (void)addCircularImage:(UIImage *)image{

    self.circularImageView = [[CircularImageView alloc] initWithFrame:CGRectMake(60, 60, 150, 150) image:image];
    
    double x = imageFrame.size.width/2-self.circularImageView.frame.size.width/2;
    double y = imageFrame.size.height/2-self.circularImageView.frame.size.height/2;
    
    self.circularImageView.frame = CGRectMake(x, y, self.circularImageView.frame.size.width, self.circularImageView.frame.size.height);
    [self.myButton addTarget:self action:@selector(showAction) forControlEvents:UIControlEventAllTouchEvents];
    [_scrollView addSubview:self.circularImageView];
}

-(void)replaceImage:(UIImage *)image {
    self.circularImageView.image = image;
}

-(void)showAction {
    NSLog(@"button pressed");
}

@end
