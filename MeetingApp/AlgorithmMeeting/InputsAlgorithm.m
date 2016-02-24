//
//  InputsAlgorithm.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/24/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "InputsAlgorithm.h"

@implementation InputsAlgorithm

- (NSArray *) getHoursAllGuests: (NSArray *) guests {

    if([guests count] == 0 ){
        NSException* myException = [NSException
                                    exceptionWithName:@"InvalidParameters"
                                    reason:@"Required guests and user information"
                                    userInfo:nil];
        [myException raise];
    } else if([guests count] < 2) {
        NSException* myException = [NSException
                                    exceptionWithName:@"InvalidParameters"
                                    reason:@"Required at least two guests"
                                    userInfo:nil];
        [myException raise];
    }
    
    [self getCountryUser];
    //NSLog(@"%@", [NSTimeZone knownTimeZoneNames]);
    
    return [self processInformationOfGuests:guests];
}

- (void) getCountryUser{
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    
    // TODO: Add the country to the user data model
}

- (NSArray *) processInformationOfGuests: (NSArray *) guests{
    
    NSDictionary *host = [guests objectAtIndex:0];
    NSMutableArray * hoursOfGuests = [[NSMutableArray alloc] init];
    
    __block int hourUser;
    [guests enumerateObjectsUsingBlock:^(NSDictionary * guest, NSUInteger index, BOOL * stop){
        if (index == 0){
            hourUser = [self getHour:host[@"codeCountry"]];
        }
        
        NSString * codeCountryGuest = guest[@"codeCountry"];
        int hourGuest = [self getHour:codeCountryGuest];
        
        if ([self validateTheSameUbicationUser: codeCountryGuest]) {
            
        }
    }];
    
    return @[];
}

- (BOOL) validateTheSameUbicationUser: (NSString *) guest{
    return YES;
}

- (int) getHour: (NSString *) hour{

    return 1;
}

@end
