//
//  Stomt.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 7/30/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StomtAgreement;

@interface Stomt : NSManagedObject

@property (nonatomic, retain) NSNumber * stomtId;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * creator;
@property (nonatomic, retain) NSNumber * isNegative;
@property (nonatomic, retain) NSNumber * counter;
@property (nonatomic, retain) NSSet *agreements;
@end

@interface Stomt (CoreDataGeneratedAccessors)

- (void)addAgreementsObject:(StomtAgreement *)value;
- (void)removeAgreementsObject:(StomtAgreement *)value;
- (void)addAgreements:(NSSet *)values;
- (void)removeAgreements:(NSSet *)values;

@end
