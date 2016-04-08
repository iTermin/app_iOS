//
//  IUserInformationDelegate.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 3/8/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUserDataSource.h"
#import "Meeting.h"


@protocol IUserDelegate <NSObject>

@optional

- (void) userInformation: (id<IUserDatasource>) userDetail
   didChangedInformation: (MutableUser *) user;

- (void) updateDetailUser: (MutableUser *) user;

- (void) updateCurrentMeetingToUser: (MutableMeeting *) meeting;

- (void) addNewMeetingToActiveMeetings:(Meeting *) meeting;

- (void) addMeetingOfActiveOrSharedMeetings: (NSString*) sectionName
             ToInactiveMeetingsInDetailUser: (MutableMeeting *) meeting;

- (void) removeMeeting: (MutableMeeting*) meeting
OfActiveOrSharedMeetingsInDetailUser: (NSString *) sectionName;

- (void) addMeetingInSharedMeetingsOfUser: (Meeting *) sharedMeeting;

@end