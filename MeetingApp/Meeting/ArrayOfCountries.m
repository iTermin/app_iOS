//
//  DictionaryOfCountries.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/28/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "ArrayOfCountries.h"

@implementation ArrayOfCountries

- (NSArray *) getModelCountries {
    NSArray *modelCountries = @[
                                @{
                                    @"name": @"China",
                                    @"dial_code": @"+86",
                                    @"code": @"CN",
                                    @"UTC" : @[@8]
                                    },
                                @{
                                    @"name": @"France",
                                    @"dial_code": @"+33",
                                    @"code": @"FR",
                                    @"UTC" : @[@1]
                                    },
                                @{
                                    @"name": @"Germany",
                                    @"dial_code": @"+49",
                                    @"code": @"DE",
                                    @"UTC" : @[@1]
                                    },
                                @{
                                    @"name": @"India",
                                    @"dial_code": @"+91",
                                    @"code": @"IN",
                                    @"UTC" : @[@(5.5)]
                                    },
                                @{
                                    @"name": @"Italy",
                                    @"dial_code": @"+39",
                                    @"code": @"IT",
                                    @"UTC" : @[@1]
                                    },
                                @{
                                    @"name": @"Japan",
                                    @"dial_code": @"+81",
                                    @"code": @"JP",
                                    @"UTC" : @[@9]
                                    },
                                @{
                                    @"name": @"Mexico",
                                    @"dial_code": @"+52",
                                    @"code": @"MX",
                                    @"UTC" : @[@(-5),@(-6),@(-7),@(-8)]
                                    },
                                @{
                                    @"name": @"United Kingdom",
                                    @"dial_code": @"+44",
                                    @"code": @"GB",
                                    @"UTC" : @[@0]
                                    },
                                @{
                                    @"name": @"United States",
                                    @"dial_code": @"+1",
                                    @"code": @"US",
                                    @"UTC" : @[@(-4),@(-5),@(-6),@(-7),@(-8),@(-9),@(-10),@(-11),@(10)]
                                    }
                                ];
    return modelCountries;
}

@end
