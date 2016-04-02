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

- (void) update: (MutableMeeting *) newMeeting;

- (void) moveToInactiveMeetings:(int) indexMeeting
          andInactiveTheMeeting: (NSString *) idMeeting;

- (void) updateDetail: (MutableMeeting *) meeting;

// TODO: Send to update the notification
- (void) updateNotification: (NotificationType) type withCallback:(void (^)(BOOL updated)) callback;

@end