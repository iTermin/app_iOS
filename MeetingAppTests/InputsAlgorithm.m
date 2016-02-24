    //
//  AlgorithmMeeting.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/20/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "Kiwi.h"
#import "InputsAlgorithm.h"

SPEC_BEGIN(PrepareInputsOfAlgorithm)

describe(@"PrepareInputsOfAlgorithm", ^{
    InputsAlgorithm * sut = [InputsAlgorithm new];
    
    context(@"when there are not guests and user information", ^{
        it(@"should notify that it's required guests and user information", ^{
            [[theBlock(^{
                [sut getHoursAllGuests:@[]];
            }) should] raiseWithName:@"InvalidParameters" reason:@"Required guests and user information"];
        });
    });
    
    context(@"when there are less than two guests", ^{
        it(@"should notify that it's required at least one guest more", ^{
            [[theBlock(^{
                [sut getHoursAllGuests:@[
                                     @{
                                         @"name": @"Estefania Chavez Guardado",
                                         @"codePhone" : @"+52",
                                         @"email": @"email@correo.mx",
                                         @"photo": @"fondo",
                                         @"codeCountry" : @"MX"
                                         }
                                     ]];
            }) should] raiseWithName:@"InvalidParameters" reason:@"Required at least two guests"];
        });
    });
    
    context(@"when at least two guests", ^{
        
        context(@"when the guest is in the same location that the user", ^{
            it(@"should return the same hour", ^{
                NSArray * hoursOfGuest = [sut getHoursAllGuests:@[
                                                              @{
                                                                  @"name": @"Estefania Chavez Guardado",
                                                                  @"codePhone" : @"+52",
                                                                  @"email": @"email@correo.mx",
                                                                  @"photo": @"fondo",
                                                                  @"codeCountry" : @"MX"
                                                                  },
                                                              @{
                                                                  @"name": @"Luis Alejandro Rangel",
                                                                  @"codePhone" : @"+52",
                                                                  @"email": @"email@correo.mx",
                                                                  @"photo": @"fondo",
                                                                  @"codeCountry" : @"MX"
                                                                  }
                                                              ]];
                [[hoursOfGuest should] equal: @[@10, @20]];
            });
        });
    });
    
});

SPEC_END

