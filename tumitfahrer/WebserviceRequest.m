//
//  WebserviceRequest.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "WebserviceRequest.h"
#import "Message.h"
#import "Conversation.h"
#import "CurrentUser.h"
#import "User.h"

@implementation WebserviceRequest

+(void)getConversationsForRideId:(NSInteger)rideId block:(boolCompletionHandler)block {
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    //    [objectManager.HTTPClient setDefaultHeader:@"Authorization: Basic" value:[self encryptCredentialsWithEmail:self.emailTextField.text password:self.passwordTextField.text]];
    
    [objectManager getObjectsAtPath:[NSString stringWithFormat:@"/api/v2/rides/%d/conversations", rideId] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        block(YES);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Load failed with error: %@", error);
        block(NO);
    }];
}

+(void)postMessageForConversation:(Conversation *)conversation message:(NSString *)message senderId:(NSNumber *)senderId receiverId:(NSNumber *)receiverId rideId:(NSNumber *)rideId block:(messageCompletionHandler)block{
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    //    [objectManager.HTTPClient setDefaultHeader:@"Authorization: Basic" value:[self encryptCredentialsWithEmail:self.emailTextField.text password:self.passwordTextField.text]];
    
    NSString *requestString = [NSString stringWithFormat:@"/api/v2/rides/%@/conversations/%@/messages?content=%@&sender_id=%@&receiver_id=%@", rideId, conversation.conversationId, [message stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], senderId, receiverId];
    
    [objectManager postObject:nil path:requestString parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        Message *message = [mappingResult firstObject];
        block(message);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        block(nil);
    }];
}

+(void)getPastRidesForCurrentUserWithBlock:(arrayCompletionHandler)block{
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSString *requestString = [NSString stringWithFormat:@"/api/v2/users/%@/rides?past=true", [CurrentUser sharedInstance].user.userId];
    
    [objectManager getObjectsAtPath:requestString parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSArray *rides = [mappingResult array];
        block(rides);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Load failed with error: %@", error);
        block(nil);
    }];
}




// ----------------------------- User --------------------------------------

+(void)getUserWithId:(NSNumber *)userId block:(userCompletionHandler)block {
    User *user = [CurrentUser getUserWithIdFromCoreData:userId];
    if(user != nil) {
        block(user);
    } else {
        RKObjectManager *objectManager = [RKObjectManager sharedManager];
        
        NSString *requestString = [NSString stringWithFormat:@"/api/v2/users/%@", [CurrentUser sharedInstance].user.userId];
        
        [objectManager getObjectsAtPath:requestString parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            User *user = [mappingResult firstObject];
            block(user);
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            RKLogError(@"Load failed with error: %@", error);
            block(nil);
        }];
    }
}

+(void)acceptRideRequestForUserId:(NSNumber *)userId rideId:(NSNumber *)rideId block:(boolCompletionHandler)block {
    block(YES);
}



@end
