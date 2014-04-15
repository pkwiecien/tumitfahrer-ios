//
//  CvLayout.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/15/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "CvLayout.h"

@implementation CvLayout

- (id)init {
	self = [super init];
	if (self) {
	}
    
	return self;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *defaultArributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    for(int i = 1; i < [defaultArributes count]; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = defaultArributes[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = defaultArributes[i - 1];
        NSInteger maximumSpacing = 5;
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    return defaultArributes;
}

-(CGFloat)minimumInteritemSpacing {
    return 5;
}

-(CGFloat)minimumLineSpacing {
    return 5;
}

-(UICollectionViewScrollDirection)scrollDirection {
    return UICollectionViewScrollDirectionVertical;
}

-(CGSize)itemSize {
    return CGSizeMake(158, 200);
}

@end
