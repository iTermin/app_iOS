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
    
    NSArray *hoursProcessed = [self addHours:numberOfHours ToEachHour:hours];
    
    NSArray *bestHours = YES == [self validateIfIsBetterOption: hoursProcessed Of: hours] ? hoursProcessed : hours;
    
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
    NSString *symbol = diferenceHours[@"symbol"];
    
    NSMutableArray * hoursProcessed = [[NSMutableArray alloc]init];
    
    if ([symbol isEqualToString:@"+"]) {
        [hours enumerateObjectsUsingBlock:^(NSNumber * hour, NSUInteger index, BOOL * stop) {
            double calculateHour = [hour intValue] + numberOfHours;
            NSNumber *newHour = [NSNumber numberWithDouble:calculateHour];
            if(calculateHour > 24){
                calculateHour = calculateHour - 24;
                newHour = [NSNumber numberWithDouble:calculateHour];
            }
            [hoursProcessed addObject:newHour];
        }];
    } else {
        [hours enumerateObjectsUsingBlock:^(NSNumber * hour, NSUInteger index, BOOL * stop) {
            double calculateHour = [hour intValue] - numberOfHours;
            NSNumber *newHour = [NSNumber numberWithDouble:calculateHour];
            if(calculateHour < 0){
                calculateHour = 24 + calculateHour;
                newHour = [NSNumber numberWithDouble:calculateHour];
            }
            [hoursProcessed addObject:newHour];
        }];
    }
    
    
    return hoursProcessed;
}

- (BOOL) validateIfIsBetterOption: (NSArray *) newProposalHours Of: (NSArray*) oldHours{

    double numberOfWorseHoursInOldHours = [self numberOfWorseHours:oldHours];
    double numberOfWorseHoursInNewProposalHours = [self numberOfWorseHours:newProposalHours];

    double probabilityOldHours = numberOfWorseHoursInOldHours / [oldHours count];

    double probabilityNewProposalHours = numberOfWorseHoursInNewProposalHours / [newProposalHours count];
    
    BOOL isBetterOptionNewProposal = probabilityNewProposalHours < probabilityOldHours ? YES : NO;
    
    return isBetterOptionNewProposal;
}

-(double) numberOfWorseHours: (NSArray *) hours{
    int maxEarlyHour = 7;
    int maxLaterHour = 21;
    
    __block double numberOfWorseHours = 0;
    [hours enumerateObjectsUsingBlock:^(NSNumber * hour, NSUInteger index, BOOL * stop) {
        int hourInt = [hour intValue];
        numberOfWorseHours = hourInt < maxEarlyHour ? numberOfWorseHours + 1 : numberOfWorseHours;
        numberOfWorseHours = hourInt > maxLaterHour ? numberOfWorseHours + 1 : numberOfWorseHours;
    }];
    
    return numberOfWorseHours;
}

@end
