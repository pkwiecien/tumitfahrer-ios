//
//  BadgeUtilities.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/17/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Badge;

@interface BadgeUtilities : NSObject

+(Badge *)fetchLastBadgeDateFromCoreData;
+(void)saveBadgeToPersisentStore:(Badge *)badge;
+(void)updateCampusDateInBadge:(NSDate*)date;
+(void)updateActivityDateInBadge:(NSDate*)date;
+(void)updateMyRidesDateInBadge:(NSDate*)date;
+(void)updateTimelineDateInBadge:(NSDate*)date;

@end
