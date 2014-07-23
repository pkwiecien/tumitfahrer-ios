//
//  BadgeUtilities.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/17/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Badge;

/**
 *  Class that handles displayig of badges in the left menu.
 */
@interface BadgeUtilities : NSObject

/**
 *  Fetches from the core data badges with time of last updating in webservice.
 *
 *  @return The Badge object.
 */
+(Badge *)fetchLastBadgeDateFromCoreData;
/**
 *  Saves an updated badge to core date.
 *
 *  @param badge The Badge object.
 */
+(void)saveBadgeToPersisentStore:(Badge *)badge;
/**
 *  Updates time of checking of campus rides.
 *
 *  @param date Time of checking campus rides
 */
+(void)updateCampusDateInBadge:(NSDate*)date;
/**
 *  Updates time of checking of activity rides.
 *
 *  @param date Time of checking activity rides
 */
+(void)updateActivityDateInBadge:(NSDate*)date;
/**
 *  Updates time of checking of my rides section.
 *
 *  @param date Time of checking my rides.
 */
+(void)updateMyRidesDateInBadge:(NSDate*)date;
/**
 *  Updates time of checking of the timeline.
 *
 *  @param date Time of checking timeline
 */
+(void)updateTimelineDateInBadge:(NSDate*)date;

@end
