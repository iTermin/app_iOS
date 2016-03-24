//
//  IUserInformationDelegate.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 3/8/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUserDataSource.h"

@protocol IUserDelegate <NSObject>

@optional

- (void) userInformation: (id<IUserDatasource>) userDetail
   didChangedInformation: (MutableUser *) user;

- (void) updateDetailUser: (MutableUser *) user;

@end