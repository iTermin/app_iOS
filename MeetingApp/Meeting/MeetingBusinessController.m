//
//  MeetingBusinessController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/27/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "MeetingBusinessController.h"

@implementation MeetingBusinessController

- (NSArray<Meeting *> *) getAllMeetings {
    return @[
             @{
                 @"active" : @(true),
                 @"date" : @"2015-12-11",
                 @"meetingId" : @"m1",
                 @"name" : @"Meeting 1"
                 },
             @{
                 @"active" : @(true),
                 @"date" : @"2015-11-15",
                 @"meetingId" : @"m2",
                 @"name" : @"Meeting 2"
                 }
             ];
}

@end
