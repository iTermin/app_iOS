//
//  InputsAlgorithm.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/24/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "InputsAlgorithm.h"

@implementation InputsAlgorithm

- (void) getHoursGuest: (NSArray *) guests {
//    __block BOOL requiredAlgoritm = NO;
//    
    if([guests count] < 2) {
        NSException* myException = [NSException
                                    exceptionWithName:@"InvalidParameters"
                                    reason:@"Required at least two guests"
                                    userInfo:nil];
        [myException raise];
    }
//    
//    
//    [hours enumerateObjectsUsingBlock:^(NSNumber * hour, NSUInteger index, BOOL * stop) {
//        requiredAlgoritm = requiredAlgoritm || [self invalidHour: hour];
//        if(requiredAlgoritm) *stop = YES;
//    }];
//    
//    return requiredAlgoritm ? [self processHours: hours] : hours;
}

@end
