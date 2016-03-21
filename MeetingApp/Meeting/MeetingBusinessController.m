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
        self.meetingsUser = [NSArray arrayWithArray:userInformation[@"meeting"]];
        self.detailMeetings = [NSMutableDictionary dictionaryWithDictionary:snapshot.value[@"Meetings"]];

        callback(weakSelf);
    }];
}

- (NSString *) userId {
    // TODO: Use real user ID
    return @"84DFC119-D29B-44AE-B8E8-257DE184279A";
}

- (NSArray<Meeting *> *) getAllMeetings
{
    return self.meetingsUser;
}


- (Meeting *) getMeetingDetail: (Meeting *) meeting
{
    return self.detailMeetings[meeting[@"id"]];
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

- (void) updateDetail:(MutableMeeting *)meeting{
    NSLog(@"%@", meeting);
}

@end
