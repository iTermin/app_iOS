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
    
    context(@"when there are less than two guests", ^{
        it(@"should notify that it's required at least one guest more", ^{
            [[theBlock(^{
                [sut getHoursGuest:@[
                                     @{
                                         @"name": @"Estefania Chavez Guardado",
                                         @"codePhone" : @"+52",
                                         @"email": @"email@correo.mx",
                                         @"photo": @"fondo",
                                         @"codeCountry" : @"MX"
                                         }//,
//                                     @{
//                                         @"name": @"Luis Alejandro Rangel",
//                                         @"codePhone" : @"+52",
//                                         @"email": @"email@correo.mx",
//                                         @"photo": @"fondo",
//                                         @"codeCountry" : @"MX"
//                                         },
//                                     @{
//                                         @"name": @"Jesus Cagide",
//                                         @"codePhone" : @"+1",
//                                         @"email": @"email@correo.mx",
//                                         @"photo": @"",
//                                         @"codeCountry" : @"US"
//                                         }
                                     ]];
            }) should] raiseWithName:@"InvalidParameters" reason:@"Required at least two guests"];
        });
    });
    
});

SPEC_END

