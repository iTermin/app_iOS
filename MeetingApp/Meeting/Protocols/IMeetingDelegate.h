//
//  IMeetingDelegate.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/27/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Meeting.h"

@protocol IMeetingDelegate <NSObject>

@optional

- (void) deleteMeeting: (Meeting *) meeting;
- (void) deleteMeetingAtIndex: (NSUInteger) index;

- (void) saveNewMeeting: (MutableMeeting *) meeting;

@end