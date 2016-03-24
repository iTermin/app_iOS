//
//  IUserInformation.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 3/8/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"

@protocol IUserDatasource <NSObject>

@optional

- (User *) getUser;
- (MutableUser *) getTemporalUser;
- (MutableUser *) getMutableUser: (User *) meeting;

- (void) updateUser: (NSString*) deviceUserId WithCallback: (void (^)(id<IUserDatasource>))callback;

@end