//
//  UserBusinessController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 3/22/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "UserBusinessController.h"
#import <Firebase/Firebase.h>

@interface UserBusinessController ()

@property (nonatomic, strong) Firebase *myRootRef;

@end

@implementation UserBusinessController

- (id) init{
    if(self = [super init]) {
        self.myRootRef = [[Firebase alloc] initWithUrl:@"https://fiery-fire-7264.firebaseio.com"];

        self.detailUser = @{
//                            @"name" : @"Estefania Chavez Guardado",
//                            @"email" : @"correo@gmail.com.mx",
//                            @"code": @"MX",
//                            @"photo" : @"",
                            };
    }
    
    return self;
}

- (void) updateUser: (NSString*) deviceUserId WithCallback: (void (^)(id<IUserDatasource>))callback{
    __weak id weakSelf = self;
    [self.myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSDictionary * info = snapshot.value[@"Users"][deviceUserId];
        self.detailUser = [NSMutableDictionary dictionaryWithDictionary:info];
        
        callback(weakSelf);
    }];
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
