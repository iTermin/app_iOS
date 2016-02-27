//
//  MainAssembly.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/27/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Typhoon/Typhoon.h>

#import "IMeetingDelegate.h"
#import "IMeetingDatasource.h"


@interface MainAssembly : TyphoonAssembly

- (id<IMeetingDatasource, IMeetingDelegate>) meetingBusinessController;

@end
