//
//  CircularImageView.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/20/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Class that creates a circular image view from the normal image.
 */
@interface CircularImageView : UIImageView

/**
 *  Inits image view with the normal image.
 *
 *  @param frame Size of the requested frame.
 *  @param image Original image.
 *
 *  @return the class object.
 */
- (id)initWithFrame:(CGRect)frame image:(UIImage *)image;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) UIColor* borderColor;
@property (nonatomic, copy) NSNumber* borderWidth;

@end
