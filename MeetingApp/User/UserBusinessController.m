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

- (void) updateUser: (NSString*) deviceUserId WithCallback: (void (^)(id<IUserDatasource>))callback{
    __weak id weakSelf = self;
    [self.myRootRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        self.deviceId = deviceUserId;
        NSDictionary * info = snapshot.value[@"Users"][deviceUserId];
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
    [self updateUser:[self getDeviceId] WithCallback:^(id<IUserDatasource> handler) {
        self.urlDetailUser = [_myRootRef childByAppendingPath:
                              [@"/Users/" stringByAppendingString:self.deviceId]];
        
        NSMutableDictionary * updateDetailUser = [NSMutableDictionary dictionaryWithDictionary:self.detailUser];
        [updateDetailUser setValue:meeting forKeyPath:@"currentMeeting"];
        [self.urlDetailUser setValue:updateDetailUser];

    }];
}


- (void) refreshInformationOfUserAddingNewMeeting:(User *) updatedInformation{ //change for updateNewMeetingsToUser
    self.urlDetailUser = [_myRootRef childByAppendingPath:
                          [@"/Users/" stringByAppendingString:self.deviceId]];
    [self.urlDetailUser setValue:updatedInformation];
}

@end
