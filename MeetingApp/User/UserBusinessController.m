//
//  UserBusinessController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 3/22/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "UserBusinessController.h"

@implementation UserBusinessController

- (id) init{
    if(self = [super init]) {
        self.detailUser = @{
//                            @"name" : @"Estefania Chavez Guardado",
//                            @"email" : @"correo@gmail.com.mx",
//                            @"code": @"MX",
//                            @"photo" : @"",
                            };
    }
    
    return self;
}

- (MutableUser *) getUser{
    return [NSMutableDictionary dictionaryWithDictionary:self.detailUser];
}

- (void) updateDetail: (MutableUser *) user{
    NSLog(@"%@", user);
}

- (MutableUser *) getTemporalUser{
    NSString *elementWillRegister = [NSString new];
    
    id temporalUser = @{
                        @"name" : elementWillRegister,
                        @"email" : elementWillRegister,
                        @"code" : elementWillRegister,
                        @"photo" : elementWillRegister
                        };
    
    return [NSMutableDictionary dictionaryWithDictionary:temporalUser];
}

@end
