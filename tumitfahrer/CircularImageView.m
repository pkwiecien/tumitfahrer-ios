//
//  CircularImageView.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/20/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "CircularImageView.h"

@implementation CircularImageView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        self.image = image;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addMaskToBounds:self.frame];
}

- (void)addMaskToBounds:(CGRect)maskBounds
{
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
	
    CGPathRef maskPath = CGPathCreateWithEllipseInRect(maskBounds, NULL);
    maskLayer.bounds = maskBounds;
	maskLayer.path = maskPath;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    
    CGPoint point = CGPointMake(maskBounds.size.width/2, maskBounds.size.height/2);
    maskLayer.position = point;
    
	[self.layer setMask:maskLayer];
    
    if ([self.borderWidth integerValue] > 0)
    {
        // create the outline layer
        CAShapeLayer*   shape   = [CAShapeLayer layer];
        shape.bounds = maskBounds;
        shape.path = maskPath;
        shape.lineWidth = [self.borderWidth doubleValue] * 2.0f;
        shape.strokeColor = self.borderColor.CGColor;
        shape.fillColor = [UIColor clearColor].CGColor;
        shape.position = point;
        
        [self.layer addSublayer:shape];
    }
    
    CGPathRelease(maskPath);
}

- (void)setup
{
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    
    self.borderWidth    = @0.0f;
    self.borderColor    = [UIColor whiteColor];
}



@end
