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
    
    return requiredAlgoritm ? [self processHours: hours] : hours;
}

- (BOOL) invalidHour: (NSNumber *) hour
{
    return [hour floatValue] < 7 || [hour floatValue] > 21;
}

- (NSArray *) processHours: (NSArray *) hours
{
    
    NSArray *hoursToProcess = [self eliminateHoursOutsideMaxEarlyAndLater: hours];
    
    NSArray *sortedHours = [self sortHours: hoursToProcess];
    
    NSDictionary *numberOfHours = [self determinateDiferenceInHours: sortedHours];
    
    NSArray *hourProcess = [self addHours:numberOfHours ToEachHour:hours];
    
    NSArray *bestHours = YES == [self validateIfIsBetterOption: hourProcess Of: hours] ? hoursToProcess : hours;
    
    return bestHours;
}

- (NSArray *) eliminateHoursOutsideMaxEarlyAndLater: (NSArray *) hours{
    __block NSMutableArray *hoursToProcess = [[NSMutableArray alloc] init];
    
    [hours enumerateObjectsUsingBlock:^(NSNumber * hour, NSUInteger index, BOOL * stop) {
        if (![self invalidHour:hour]){
            [hoursToProcess addObject:hour];
        }
    }];
    
    return hoursToProcess;
}

- (NSArray *) sortHours: (NSArray *) hours{
    return [hours sortedArrayUsingSelector: @selector(compare:)];
}

- (NSDictionary *) determinateDiferenceInHours: (NSArray *) hours{
    NSInteger earlyHour = [hours.firstObject integerValue];
    NSInteger laterHour = [hours.lastObject integerValue];
    
    NSInteger respectMaxLaterHour = 21 - laterHour;
    NSInteger respectMaxEarlyHour = earlyHour - 7;
    
    NSInteger diferenceHours = respectMaxLaterHour > respectMaxEarlyHour ? respectMaxLaterHour : respectMaxEarlyHour;
    
    NSString *symbol = diferenceHours == respectMaxLaterHour ? @"+" : @"-";

    NSDictionary *addHours = @{
                               @"number" : @(diferenceHours),
                               @"symbol" : symbol
    };
    return addHours;
}

- (NSArray *) addHours: (NSDictionary *) diferenceHours ToEachHour: (NSArray *) hours
{
    NSInteger numberOfHours = [diferenceHours[@"number"] integerValue];
    
    NSMutableArray * hoursProcess = [[NSMutableArray alloc]init];
    
    [hours enumerateObjectsUsingBlock:^(NSNumber * hour, NSUInteger index, BOOL * stop) {
        NSInteger sumHours = [hour intValue] + numberOfHours;
        NSNumber *newHour = [NSNumber numberWithDouble:sumHours];
        [hoursProcess addObject:newHour];
    }];
    
    return hoursProcess;
}

- (BOOL) validateIfIsBetterOption: (NSArray *) newProposalHours Of: (NSArray*) oldHours{

    double numberOfWorseHoursInOldHours = [self numberOfWorseHours:oldHours];
    double numberOfWorseHoursInNewProposalHours = [self numberOfWorseHours:newProposalHours];

    double probabilityOldHours = numberOfWorseHoursInOldHours / [oldHours count];

    double probabilityNewProposalHours = numberOfWorseHoursInNewProposalHours / [newProposalHours count];
    
    BOOL isBetterOptionNewProposal = probabilityNewProposalHours > probabilityOldHours ? YES : NO;
    
    return isBetterOptionNewProposal;
}

-(double) numberOfWorseHours: (NSArray *) hours{
    NSNumber *maxEarlyHour = [NSNumber numberWithInt:7];
    NSNumber *maxLaterHour = [NSNumber numberWithInt:21];
    
    __block double numberOfWorseHours = 0;
    [hours enumerateObjectsUsingBlock:^(NSNumber * hour, NSUInteger index, BOOL * stop) {
        numberOfWorseHours = hour <= maxEarlyHour ? numberOfWorseHours + 1 : numberOfWorseHours;
        numberOfWorseHours = hour >= maxLaterHour ? numberOfWorseHours + 1 : numberOfWorseHours;
    }];
    
    return numberOfWorseHours;
}

@end
