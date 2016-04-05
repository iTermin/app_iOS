//
//  MeetingBusinessController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/27/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IMeetingDatasource.h"
#import "IMeetingDelegate.h"


@interface MeetingBusinessController : NSObject <IMeetingDatasource, IMeetingDelegate>

@property (nonatomic, retain) NSMutableDictionary <NSString *, Meeting *> * detailMeetings;
@property (nonatomic, retain) NSArray * meetingsUser;
@property (nonatomic, retain) NSMutableDictionary * allMeetings;

@end
