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
        self.deviceId = deviceUserId;
        NSDictionary * info = snapshot.value[@"Users"][deviceUserId];
        self.detailUser = [NSMutableDictionary dictionaryWithDictionary:info];
        
        callback(weakSelf);
    }];
}

- (MutableUser *) getUser{
    return [NSMutableDictionary dictionaryWithDictionary:self.detailUser];
}

- (NSString*) urlDetailUser: (NSString*) detail{
    return [[[@"/Users/" stringByAppendingString:self.deviceId]
            stringByAppendingString: @"/"] stringByAppendingString:detail];
}

- (void) updateDetailUser: (MutableUser *) user{
    Firebase * usersRef = [_myRootRef childByAppendingPath:[self urlDetailUser:@"code"]];
    [usersRef setValue: @"DE"];
    
//    usersRef = [_myRootRef childByAppendingPath:[self urlDetailUser:@"name"]];
//    [usersRef setValue: user[@"name"]];
//    
//    usersRef = [_myRootRef childByAppendingPath:[self urlDetailUser:@"email"]];
//    [usersRef setValue: user[@"email"]];
//    
//    usersRef = [_myRootRef childByAppendingPath:[self urlDetailUser:@"photo"]];
//    [usersRef setValue: user[@"photo"]];

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
