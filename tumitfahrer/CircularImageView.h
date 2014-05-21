//
//  CircularImageView.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/20/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircularImageView : UIImageView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) UIColor* borderColor;
@property (nonatomic, copy) NSNumber* borderWidth;

@end
