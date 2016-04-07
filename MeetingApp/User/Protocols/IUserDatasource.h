//
//  IUserInformation.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 3/8/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"
#import "Meeting.h"


@protocol IUserDatasource <NSObject>

@optional

- (User *) getUser;
- (MutableUser *) getTemporalUser;
- (MutableUser *) getMutableUser: (User *) meeting;

- (MutableMeeting *) getTemporalNewMeeting: (NSString *) idMeeting;

- (void) updateUserWithCallback: (void (^)(id<IUserDatasource>))callback;

@end