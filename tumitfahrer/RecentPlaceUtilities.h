//
//  RecentPlaceUtilities.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/18/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RecentPlaceUtilities : NSObject

+(NSArray *)fetchPlacesFromCoreData;
+(void)createRecentPlaceWithName:(NSString *)name coordinate:(CLLocationCoordinate2D)coordinate;

@end
