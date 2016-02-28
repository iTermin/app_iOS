//
//  MainAssembly.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/27/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "MainAssembly.h"

#import "MeetingBusinessController.h"

@implementation MainAssembly

- (id<IMeetingDatasource, IMeetingDelegate>)meetingBusinessController
{
    return [TyphoonDefinition withClass:[MeetingBusinessController class] configuration:^(TyphoonDefinition *definition) {
        [definition setScope: TyphoonScopeLazySingleton];
    }];
}

@end
