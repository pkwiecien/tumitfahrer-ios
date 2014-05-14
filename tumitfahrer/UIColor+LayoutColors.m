//
//  UIColor+LayoutColors.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/14/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "UIColor+LayoutColors.h"

@implementation UIColor (LayoutColors)

+ (UIColor *)lightestBlue {
    return [UIColor colorWithRed:0.325 green:0.655 blue:0.835 alpha:1];
}

+ (UIColor *)lighterBlue {
    return [UIColor colorWithRed:0 green:0.463 blue:0.722 alpha:1];
}

+ (UIColor *)darkerBlue {
    return [UIColor colorWithRed:0 green:0.361 blue:0.588 alpha:1];
}

+ (UIColor *)darkestBlue {
    return [UIColor colorWithRed:0.059 green:0.216 blue:0.314 alpha:1];
}

@end
