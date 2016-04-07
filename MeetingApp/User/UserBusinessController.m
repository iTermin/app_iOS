//
//  UserBusinessController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 3/22/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "UserBusinessController.h"
#import <Firebase/Firebase.h>
#import <AdSupport/ASIdentifierManager.h>


@interface UserBusinessController ()

@property (nonatomic, strong) Firebase *myRootRef;
@property (nonatomic, strong) Firebase * urlDetailUser;

@end

@implementation UserBusinessController

- (id) init{
    if(self = [super init]) {
        self.myRootRef = [[Firebase alloc] initWithUrl:@"https://fiery-fire-7264.firebaseio.com"];
    }
    
    return self;
}

- (void) updateUserWithCallback: (void (^)(id<IUserDatasource>))callback{
    __weak id weakSelf = self;
    [self.myRootRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        self.deviceId = [self getDeviceId];
        NSDictionary * info = snapshot.value[@"Users"][self.deviceId];
        self.detailUser = [NSMutableDictionary dictionaryWithDictionary:info];
        
        callback(weakSelf);
    }];
}

- (MutableUser *) getUser{
    return [NSMutableDictionary dictionaryWithDictionary:self.detailUser];
}

- (NSString*) urlDetailUser: (NSString*) detail{
    return [[[@"/Users/" stringByAppendingString:self.deviceId]
            stringByAppendingString: @"/"] stringByAppendingString:detail];
}

- (void) updateDetailUser: (MutableUser *) user{
    
    if(![self.detailUser[@"code"] isEqual:[user valueForKeyPath:@"code"]]){
        self.urlDetailUser = [_myRootRef childByAppendingPath:[self urlDetailUser:@"code"]];
        [self.urlDetailUser setValue:[user valueForKeyPath:@"code"]];
    }
    if(![self.detailUser[@"name"] isEqual:[user valueForKeyPath:@"name"]]){
        self.urlDetailUser = [_myRootRef childByAppendingPath:[self urlDetailUser:@"name"]];
        [self.urlDetailUser setValue:[user valueForKeyPath:@"name"]];
    }
    if(![self.detailUser[@"email"] isEqual:[user valueForKeyPath:@"email"]]){
        self.urlDetailUser = [_myRootRef childByAppendingPath:[self urlDetailUser:@"email"]];
        [self.urlDetailUser setValue:[user valueForKeyPath:@"email"]];
    }
    if(![self.detailUser[@"photo"] isEqual:[user valueForKeyPath:@"photo"]]){
        self.urlDetailUser = [_myRootRef childByAppendingPath:[self urlDetailUser:@"photo"]];
        [self.urlDetailUser setValue:[user valueForKeyPath:@"photo"]];
    }
}

- (MutableUser *) getTemporalUser{
    NSString *elementWillRegister = [NSString new];
    
    id temporalUser = @{
                        @"name" : elementWillRegister,
                        @"email" : elementWillRegister,
                        @"code" : elementWillRegister,
                        @"photo" : elementWillRegister
                        };
    
    return [NSMutableDictionary dictionaryWithDictionary:temporalUser];
}

- (MutableMeeting *) getTemporalNewMeeting: (NSString *) idMeeting{
    id temporalNewMeeting = @{
                        @"date" : @"init",
                        @"meetingId" : idMeeting,
                        @"name" : @"init",
                        };
    
    return [NSMutableDictionary dictionaryWithDictionary:temporalNewMeeting];
}

- (NSString*) getDeviceId{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

- (void) updateCurrentMeetingToUser: (MutableMeeting *) meeting{
    [self updateUserWithCallback:^(id<IUserDatasource> handler) {
        
        if ([self.detailUser[@"currentMeeting"] count]) {
            
            self.urlDetailUser = [_myRootRef childByAppendingPath:
                                  [[@"/Users/" stringByAppendingString:self.deviceId]
                                   stringByAppendingString:@"/currentMeeting"]];
            [self.urlDetailUser setValue:meeting];
            
        } else {
            
            self.urlDetailUser = [_myRootRef childByAppendingPath:
                                  [@"/Users/" stringByAppendingString:self.deviceId]];
            NSMutableDictionary * updateDetailUser = [NSMutableDictionary dictionaryWithDictionary:self.detailUser];
            [updateDetailUser setValue:meeting forKeyPath:@"currentMeeting"];
            [self.urlDetailUser setValue:meeting];
        }
    }];
}

- (void) addMeetingOfActiveOrSharedMeetings: (NSString*) sectionName
             ToInactiveMeetingsInDetailUser: (MutableMeeting *) meeting {
    
    [self updateUserWithCallback:^(id<IUserDatasource> handler) {
        NSDictionary * userDetail = [NSDictionary dictionaryWithDictionary:self.detailUser];

        __block NSMutableArray * inactiveMeetings = [NSMutableArray arrayWithArray:userDetail[@"inactiveMeetings"]];
        
        if ([sectionName isEqualToString:@"activeMeeting"]) {
            NSMutableArray * activeMetings = [NSMutableArray arrayWithArray:userDetail[@"activeMeetings"]];
            [activeMetings enumerateObjectsUsingBlock:^(NSMutableDictionary * aMeeting, NSUInteger idx, BOOL * stop) {
                if ([[meeting valueForKey:@"meetingId"] isEqualToValue:[aMeeting valueForKey:@"meetingId"]]) {
                    [inactiveMeetings addObject:[NSDictionary dictionaryWithDictionary:activeMetings[idx]]];
                }
            }];
            
        } else if ([sectionName isEqualToString:@"sharedMeeting"]) {
            NSMutableArray * sharedMeetings = [NSMutableArray arrayWithArray:userDetail[@"sharedMeetings"]];
            [sharedMeetings enumerateObjectsUsingBlock:^(NSMutableDictionary * sMeeting, NSUInteger idx, BOOL * stop) {
                if ([[meeting valueForKey:@"meetingId"] isEqual:[sMeeting valueForKey:@"meetingId"]]) {
                    [inactiveMeetings addObject:[NSDictionary dictionaryWithDictionary:sharedMeetings[idx]]];
                }
            }];
            
        }

        self.urlDetailUser = [_myRootRef childByAppendingPath:
                            [[@"/Users/" stringByAppendingString:self.deviceId]
                             stringByAppendingString:@"/inactiveMeetings"]];
        [self.urlDetailUser setValue:inactiveMeetings];
    }];

}

- (void) removeMeeting: (MutableMeeting*) meeting
        OfActiveOrSharedMeetingsInDetailUser: (NSString *) sectionName{
    
    [self updateUserWithCallback:^(id<IUserDatasource> handler) {
        NSDictionary * userDetail = [NSDictionary dictionaryWithDictionary:self.detailUser];

        if ([sectionName isEqualToString:@"activeMeeting"]) {
            
            NSMutableArray * activeMetings = [NSMutableArray arrayWithArray:userDetail[@"activeMeetings"]];
            [activeMetings enumerateObjectsUsingBlock:^(NSMutableDictionary * aMeeting, NSUInteger idx, BOOL * stop) {
                if ([[meeting valueForKey:@"meetingId"] isEqualToValue:[aMeeting valueForKey:@"meetingId"]]) {
                    [activeMetings removeObjectAtIndex:idx];
                }
            }];
            
            self.urlDetailUser = [_myRootRef childByAppendingPath:
                                  [[@"/Users/" stringByAppendingString:self.deviceId]
                                   stringByAppendingString:@"/activeMeetings"]];
            [self.urlDetailUser setValue:activeMetings];
            
        } else if ([sectionName isEqualToString:@"sharedMeeting"]) {
            
            NSMutableArray * sharedMeetings = [NSMutableArray arrayWithArray:userDetail[@"sharedMeetings"]];
            [sharedMeetings enumerateObjectsUsingBlock:^(NSMutableDictionary * sMeeting, NSUInteger idx, BOOL * stop) {
                if ([[meeting valueForKey:@"meetingId"] isEqual:[sMeeting valueForKey:@"meetingId"]]) {
                    [sharedMeetings removeObjectAtIndex:idx];
                }
            }];

            self.urlDetailUser = [_myRootRef childByAppendingPath:
                                  [[@"/Users/" stringByAppendingString:self.deviceId]
                                   stringByAppendingString:@"/sharedMeetings"]];
            [self.urlDetailUser setValue:sharedMeetings];
        }
        
    }];
}


- (void) updateInformationUserWithNewMeeting:(User *) detailUser{
    self.urlDetailUser = [_myRootRef childByAppendingPath:
                          [@"/Users/" stringByAppendingString:self.deviceId]];
    [self.urlDetailUser setValue:detailUser];
}

@end
