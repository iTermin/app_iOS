//
//  IMeetingDatasource.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/27/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Meeting.h"
#import "IMeetingDatasource.h"

@protocol IMeetingDatasource <NSObject>

- (void) updateMeetingsWithCallback: (void (^)(id<IMeetingDatasource>, NSArray<Meeting *> *))callback;
- (NSArray<Meeting *> *) getAllMeetings;
- (Meeting *) getMeetingDetail: (Meeting *) meeting;
- (MutableMeeting *) getTemporalMeeting;

@optional

- (MutableMeeting *) getMutableMeeting: (Meeting *) meeting;

@end