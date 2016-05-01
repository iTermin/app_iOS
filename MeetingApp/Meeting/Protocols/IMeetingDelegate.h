//
//  IMeetingDelegate.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/27/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Meeting.h"

typedef enum  NotificationType {
    NOTIFICATION_TYPE_EMAIL,
    NOTIFICATION_TYPE_CALENDAR
} NotificationType;

@protocol IMeetingDelegate <NSObject>

@optional

- (void) updateNewMeeting: (MutableMeeting *) newMeeting;

- (void) updateNewMeeting: (MutableMeeting *) newMeeting withCallback: (void (^)()) callback;

- (void) updateNotifications: (MutableMeeting *) detailMeeting InMeeting:(Meeting *) meeting;

- (void) setInactiveInDetailOfMeeting: (NSString *) meetingId;

// TODO: Send to update the notification
- (void) updateNotification: (NotificationType) type withCallback:(void (^)(BOOL updated)) callback;

@end