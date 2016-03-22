//
//  UserBusinessController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 3/22/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IUserDatasource.h"
#import "IUserDelegate.h"

@interface UserBusinessController : NSObject <IUserDelegate, IUserDatasource>

@property (nonatomic, retain) NSDictionary <NSString *, User *> * detailUser;

@end
