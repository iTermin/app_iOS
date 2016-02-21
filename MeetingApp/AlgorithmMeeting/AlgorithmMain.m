//
//  AlgorithmMain.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/20/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "AlgorithmMain.h"

@implementation AlgorithmMain

- (NSArray * ) getHourProposal: (NSArray *) hours
{
    __block BOOL requiredAlgoritm = NO;
    
    if([hours count] < 2) {
        NSException* myException = [NSException
                                    exceptionWithName:@"InvalidParameters"
                                    reason:@"Required at least two guests"
                                    userInfo:nil];
        [myException raise];
    }
    
    
    [hours enumerateObjectsUsingBlock:^(NSNumber * hour, NSUInteger index, BOOL * stop) {
        requiredAlgoritm = requiredAlgoritm || [self invalidHour: hour];
        if(requiredAlgoritm) *stop = YES;
    }];
    
    return  requiredAlgoritm ? [self processHours: hours] : hours;
}

- (BOOL) invalidHour: (NSNumber *) hour
{
    return [hour floatValue] < 7 || [hour floatValue] > 21;
}

- (NSArray *) processHours: (NSArray *) hours
{
    return @[];
}

@end
