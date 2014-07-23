//
//  RecentPlaceUtilities.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/18/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 *  Class that handles the RecentPlace objects from the core data.
 */
@interface RecentPlaceUtilities : NSObject

/**
 *  Fetches all user's RecentPlaces from the core data. RecentPlace object is based on the search history.
 *
 *  @return Array with user's RecentPlaces.
 */
+(NSArray *)fetchPlacesFromCoreData;
/**
 *  Creates a RecentPlace with given coordinates for the current user. Recent place is based on the search query and is either destination or departure place.
 *
 *  @param name       Name of the recent place from the Google Places API
 *  @param coordinate Coordinates of the object with recent place.
 */
+(void)createRecentPlaceWithName:(NSString *)name coordinate:(CLLocationCoordinate2D)coordinate;

@end
