//
//  MeetingBusinessController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/27/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "MeetingBusinessController.h"
#import <Firebase/Firebase.h>
#import <AdSupport/ASIdentifierManager.h>

@interface MeetingBusinessController ()

@property (nonatomic, strong) Firebase *myRootRef;
@property (nonatomic, strong) Firebase * urlMeetings;

@end

@implementation MeetingBusinessController

-(instancetype) init {
    if(self = [super init]) {
        [Firebase defaultConfig].persistenceEnabled = YES;
        self.myRootRef = [[Firebase alloc] initWithUrl:@"https://fiery-fire-7264.firebaseio.com"];
    }
    
    return self;
}

- (void) updateMeetingsWithCallback: (void (^)(id<IMeetingDatasource>))callback {
    __weak id weakSelf = self;
    [self.myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSDictionary * info = snapshot.value[@"Users"][self.userId];
        self.allMeetings = snapshot.value[@"Meetings"];

        NSDictionary * userInformation = [NSDictionary dictionaryWithDictionary:info ];
        self.meetingsUser = [NSArray arrayWithArray:userInformation[@"activeMeetings"]];
        self.detailMeetings = [NSMutableDictionary dictionaryWithDictionary:snapshot.value[@"Meetings"]];

        callback(weakSelf);
    }];
}

- (NSString *) userId {
    //UIDevice *device = [UIDevice currentDevice];
    //return [[device identifierForVendor]UUIDString];
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

- (NSArray<Meeting *> *) getAllMeetings
{
    return [NSArray arrayWithArray:[self returnMeetingsActiveDate]];
    //return self.meetingsUser;
}

- (NSMutableArray *) returnMeetingsActiveDate{

    __block NSDate* currentDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss ZZZZ"];
    
    NSMutableArray * meetingsActiveDate = [NSMutableArray array];
    
    [self.meetingsUser enumerateObjectsUsingBlock:^(id meeting, NSUInteger idx, BOOL * stop) {
        NSDate *dateMeeting = [dateFormatter dateFromString:[meeting valueForKey:@"date"]];
        
        if ([currentDate compare:dateMeeting] == NSOrderedAscending) {
            [meetingsActiveDate addObject:[NSDictionary dictionaryWithDictionary:meeting]];
        }
        
    }];
    
    return meetingsActiveDate;
    
}

- (Meeting *) getMeetingDetail: (Meeting *) meeting
{
    return self.detailMeetings[meeting[@"meetingId"]];
}

- (NSString *) uuIdMeeting {
    return [[NSUUID UUID] UUIDString];
}

- (MutableMeeting *) getTemporalMeeting
{
    NSMutableArray *guests = [NSMutableArray arrayWithObjects:@"init", nil];
    NSMutableDictionary *detail = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"init", @"init", nil];
    
    NSString *idMeeting = [self uuIdMeeting];
    
    id temporalMeeting = [NSMutableDictionary dictionaryWithDictionary:@{
                                idMeeting: @{
                                        @"detail": detail,
                                        @"guests": guests
                                        }
                                }];
    
    return [NSMutableDictionary dictionaryWithDictionary: temporalMeeting];
}

- (void) updateNewMeeting: (MutableMeeting *) newMeeting{
    [self updateNewMeeting:newMeeting withCallback:nil];
}

- (void) updateNewMeeting: (MutableMeeting *) newMeeting withCallback: (void (^)()) callback {
    NSMutableDictionary * updateAllMeetings = [NSMutableDictionary dictionaryWithDictionary:self.allMeetings];
    [updateAllMeetings addEntriesFromDictionary:newMeeting];
    
    self.urlMeetings = [_myRootRef childByAppendingPath:@"/Meetings"];
    [self.urlMeetings setValue:updateAllMeetings withCompletionBlock:^(NSError *error, Firebase *ref) {
        if(callback) {
            callback();
        }
    }];
}

- (void) setInactiveInDetailOfMeeting: (NSString *) meetingId {
    NSMutableDictionary * setInactiveDetailMeeting = self.detailMeetings[meetingId][@"detail"];
    
    [setInactiveDetailMeeting setValue:@NO forKey:@"active"];
    
    self.urlMeetings = [_myRootRef childByAppendingPath:
                        [[@"/Meetings/" stringByAppendingString:meetingId]
                         stringByAppendingString:@"/detail"]];
    
    [self.urlMeetings setValue:setInactiveDetailMeeting];
}

- (void) updateNotifications:(MutableMeeting *)detailMeeting InMeeting:(Meeting *)meeting{
    self.urlMeetings = [_myRootRef childByAppendingPath:
                       [[@"/Meetings/" stringByAppendingString:meeting[@"meetingId"]]
                         stringByAppendingString:@"/detail"]];
    [self.urlMeetings setValue:detailMeeting];
}

@end
