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

- (User *) getUser;
//- (User *) allUsersIdentify: (User *) user;
//- (MutableUser *) getTemporalUser;

@optional

- (MutableUser *) getMutableUser: (User *) meeting;

@end