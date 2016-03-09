//
//  IUserInformationDelegate.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 3/8/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUserInformation.h"

@protocol IUserInformationDelegate <NSObject>

- (void) userInformation: (id<IUserInformation>) userDetail
    didChangedInformation: (NSDictionary *) user;

@end
