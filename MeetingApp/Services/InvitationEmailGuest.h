//
//  InvitationEmailGuest.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 4/30/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvitationEmailGuest : NSObject

- (void) sendInvitationToGuestOfMeeting: (NSString *) meetingId;

@end
