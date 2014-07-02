//
//  KIFUITestActor+EXAdditions.h
//  tumitfahrer
//
//  Created by Automotive Service Lab on 02/07/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "KIFUITestActor.h"
extern NSInteger const kDESTINATION_ADD;
extern NSInteger const kDEPARTURE_ADD;
extern NSInteger const kDESTINATION_SEARCH;
extern NSInteger const kDEPARTURE_SEARCH;
@interface KIFUITestActor (EXAdditions)

#pragma mark - test cases
-(void)addRideAsPassengerWithCampusRide;

-(void)addRideAsPassengerWithCampusRideWithSearch;

-(void)addRideAsPassengerWithActivityRide;

-(void)addRideAsPassengerWithActivityRideWithSearch;

-(void)addRideAsDriverWithCampusRide;

-(void)addRideAsDriverWithCampusRideWithSearch;

-(void)addRideAsDriverWithActivityRide;

-(void)addRideAsDriverWithActivityRideWithSearch;

-(void)searchRideWithCampusRideWithRadius0WithoutTime;

-(void)searchRideWithCampusRideWithRadius30WithoutTime;

-(void)searchRideWithCampusRideWithRadius30WithTime;

-(void)searchRideWithCampusRideWithRadius0WithTime;

-(void)searchRideWithCampusRideWithRadius0WithTimeWithSearch;

-(void)searchRideWithActivityRideWithRadius0WithTimeWithSearch;

-(void)deleteRideAsRequest;

-(void)deleteRideAsOffer;

@end
