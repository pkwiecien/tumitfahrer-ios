//
//  BadgeUtilities.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/17/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "BadgeUtilities.h"
#import "Badge.h"

@implementation BadgeUtilities

// fetch all past rides
+(Badge *)fetchLastBadgeDateFromCoreData {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Badge"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"badgeId = 0"];
    [request setPredicate:predicate];
    
    request.entity = e;
    
    NSError *error;
    NSArray *fetchedObjects = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:&error];
    if (!fetchedObjects) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    
    Badge *badge = [fetchedObjects firstObject];
    
    return badge;
}

+(void)updateTimelineDateInBadge:(NSDate*)date {
    Badge *badge = [self fetchLastBadgeDateFromCoreData];
    badge.timelineUpdatedAt = date;
    [self saveBadgeToPersisentStore:badge];
}

+(void)updateMyRidesDateInBadge:(NSDate*)date {
    Badge *badge = [BadgeUtilities fetchLastBadgeDateFromCoreData];
    badge.myRidesUpdatedAt = date;
    badge.myRidesBadge = [NSNumber numberWithInt:0];
    [BadgeUtilities saveBadgeToPersisentStore:badge];
}

+(void)updateCampusDateInBadge:(NSDate*)date {
    Badge *badge = [BadgeUtilities fetchLastBadgeDateFromCoreData];
    badge.campusUpdatedAt = date;
    badge.campusBadge = [NSNumber numberWithInt:0];
    [BadgeUtilities saveBadgeToPersisentStore:badge];
}

+(void)updateActivityDateInBadge:(NSDate*)date {
    Badge *badge = [BadgeUtilities fetchLastBadgeDateFromCoreData];
    badge.activityUpdatedAt = date;
    badge.activityBadge = [NSNumber numberWithInt:0];
    [BadgeUtilities saveBadgeToPersisentStore:badge];
}


+(void)saveBadgeToPersisentStore:(Badge *)badge {
    
    NSManagedObjectContext *context = badge.managedObjectContext;
    NSError *error;
    if (![context saveToPersistentStore:&error]) {
        NSLog(@"delete error %@", [error localizedDescription]);
    }
}

@end
