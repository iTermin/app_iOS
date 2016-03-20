//
//  MeetingBusinessController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/27/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "MeetingBusinessController.h"

@implementation MeetingBusinessController

- (id) init {
    if(self = [super init]) {
        self.detailMeetings = [NSMutableDictionary dictionaryWithDictionary: @{
        @"m1" : @{
            @"detail" : @{
                @"creator" : @0,
                @"date" : @1448008691974,
                @"duration" : @360,
                @"name" : @"Meeting 1"
            },
            @"guests" : @[ @{
                @"email" : @"fachinacg@gmail.com",
                @"name" : @"Estefania Guardado",
                @"photo" : @""
            }, @{
                @"email" : @"xlarsx@gmail.com",
                @"name" : @"Luis Alejandro Rangel",
                @"photo" : @""
            }, @{
                @"email" : @"set311@gmail.com",
                @"name" : @"Jesus Cagide",
                @"photo" : @""
            } ],
            @"notifications" : @{
                @"apn" : @NO,
                @"calendar" : @NO,
                @"email" : @NO,
                @"reminder" : @NO
            }
        },
        @"m2" : @{
            @"detail" : @{
                @"creator" : @0,
                @"date" : @1449822758952,
                @"duration" : @360,
                @"name" : @"Meeting 2"
            },
            @"guests" : @[ @{
                @"email" : @"fachinacg@gmail.com",
                @"name" : @"Estefania Guardado",
                @"photo" : @""
            }, @{
                @"email" : @"xlarsx@gmail.com",
                @"name" : @"Luis Alejandro Rangel",
                @"photo" : @""
            } ],
            @"notifications" : @{
                @"apn" : @NO,
                @"calendar" : @NO,
                @"email" : @NO,
                @"reminder" : @NO
            }
        }}];
    }
    
    return self;
}

- (NSArray<Meeting *> *) getAllMeetings
{
    return @[
             @{
                 @"id"     : @"m1",
                 @"active" : @(true),
                 @"date" : @"2015-12-11",
                 @"meetingId" : @"m1",
                 @"name" : @"Meeting 1"
                 },
             @{
                 @"id"     : @"m2",
                 @"active" : @(true),
                 @"date" : @"2015-11-15",
                 @"meetingId" : @"m2",
                 @"name" : @"Meeting 2"
                 }
             ];
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

- (void) updateDetail:(Meeting *)meeting{
    NSLog(@"%@", meeting);
}

@end
