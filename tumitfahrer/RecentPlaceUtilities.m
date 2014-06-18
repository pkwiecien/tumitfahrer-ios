//
//  RecentPlaceUtilities.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/18/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RecentPlaceUtilities.h"
#import "ActionManager.h"

@implementation RecentPlaceUtilities

+(NSArray *)fetchPlacesFromCoreData {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"RecentPlace"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    request.sortDescriptors = @[descriptor];
    
    request.entity = e;
    
    NSError *error;
    NSArray *fetchedObjects = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:&error];
    if (!fetchedObjects) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    return fetchedObjects;
}

+(void)createRecentPlaceWithName:(NSString *)name coordinate:(CLLocationCoordinate2D)coordinate {
    
    NSManagedObject *recentPlace = [NSEntityDescription
                                          insertNewObjectForEntityForName:@"RecentPlace"
                                          inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext];
    [recentPlace setValue:[ActionManager currentDate]  forKey:@"createdAt"];
    [recentPlace setValue:name forKey:@"placeName"];
    [recentPlace setValue:[NSNumber numberWithDouble:coordinate.latitude] forKey:@"placeLatitude"];
    [recentPlace setValue:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"placeLongitude"];
    NSError *error;
    
    if (![[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext saveToPersistentStore:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

@end
