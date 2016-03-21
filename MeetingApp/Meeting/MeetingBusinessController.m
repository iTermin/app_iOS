//
//  MeetingBusinessController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/27/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "MeetingBusinessController.h"
#import <Firebase/Firebase.h>

@implementation MeetingBusinessController

- (id) init {
    if(self = [super init])
        [self updateFirebase];
    
    return self;
}

- (void) updateFirebase {
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://fiery-fire-7264.firebaseio.com"];
    
    [myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSDictionary * userInformation = [NSDictionary
                                          dictionaryWithDictionary:snapshot.value[@"Users"][@"84DFC119-D29B-44AE-B8E8-257DE184279A"]];
        
        NSArray * temp = [NSArray arrayWithArray:self.meetingsUser];
        self.meetingsUser = [NSArray arrayWithArray:userInformation[@"meeting"]];
        
        if (![temp isEqualToArray:self.meetingsUser])
            NSLog(@"%@", self.meetingsUser);
        
        self.detailMeetings = [NSMutableDictionary dictionaryWithDictionary:snapshot.value[@"Meetings"]];
    }];
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
