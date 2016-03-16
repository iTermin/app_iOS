//
//  IMeetingAllDayDelegate.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 3/16/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMeetingAllDayDelegate <NSObject>

- (void) meetingAllDay: (BOOL) selected;

@end
