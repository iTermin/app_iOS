//
//  IMeetingDatasource.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/27/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Meeting.h"

@protocol IMeetingDatasource <NSObject>

- (NSArray<Meeting *> *) getAllMeetings;
- (Meeting *) getMeetingDetail: (Meeting *) meeting;

@optional

- (MutableMeeting *) getTemporalMeeting;
- (MutableMeeting *) getMutableMeeting: (Meeting *) meeting;

@end