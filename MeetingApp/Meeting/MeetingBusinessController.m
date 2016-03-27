//
//  MeetingBusinessController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/27/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "MeetingBusinessController.h"
#import <Firebase/Firebase.h>

@interface MeetingBusinessController ()

@property (nonatomic, strong) Firebase *myRootRef;
@property (nonatomic, strong) Firebase * urlMeetings;

@end

@implementation MeetingBusinessController

-(instancetype) init {
    if(self = [super init]) {
        self.myRootRef = [[Firebase alloc] initWithUrl:@"https://fiery-fire-7264.firebaseio.com"];
    }
    
    return self;
}

- (void) updateMeetingsWithCallback: (void (^)(id<IMeetingDatasource>))callback {
    __weak id weakSelf = self;
    [self.myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSDictionary * info = snapshot.value[@"Users"][self.userId];
        NSDictionary * userInformation = [NSDictionary dictionaryWithDictionary:info];
        self.meetingsUser = [NSArray arrayWithArray:userInformation[@"activeMeetings"]];
        self.detailMeetings = [NSMutableDictionary dictionaryWithDictionary:snapshot.value[@"Meetings"]];

        callback(weakSelf);
    }];
}

- (NSString *) userId {
    UIDevice *device = [UIDevice currentDevice];
        
    return [[device identifierForVendor]UUIDString];
}

- (NSArray<Meeting *> *) getAllMeetings
{
    return self.meetingsUser;
}


- (Meeting *) getMeetingDetail: (Meeting *) meeting
{
    return self.detailMeetings[meeting[@"meetingId"]];
}

- (MutableMeeting *) getTemporalMeeting
{
    NSMutableArray *guests = [NSMutableArray array];
    NSMutableDictionary *detail = [NSMutableDictionary dictionary];
    
    id temporalMeeting = @{
              @"detail" : detail,
              @"guests" : guests,
    };
    
    return [NSMutableDictionary dictionaryWithDictionary: temporalMeeting];
}

- (void) update: (MutableMeeting *) newMeeting{
    [self.detailMeetings addEntriesFromDictionary:newMeeting];
    
    self.urlMeetings = [_myRootRef childByAppendingPath:@"/Meetings"];
    [self.urlMeetings setValue:self.detailMeetings];
}

- (void) updateDetail:(MutableMeeting *)meeting{
    
    NSLog(@"%@", meeting);
}

@end
