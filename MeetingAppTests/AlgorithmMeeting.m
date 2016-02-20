//
//  AlgorithmMeeting.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/20/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "Kiwi.h"
#import "AlgorithmMain.h"

SPEC_BEGIN(AlgorithmMeeting)
describe(@"The hours", ^{
    
    __block NSMutableArray *guestTimes = [[NSMutableArray alloc] init];
    
    context(@"when will be created Meeting", ^{
        
        it(@"is not empty", ^{
            [[guestTimes shouldNot] beEmpty];
        });
    });
    
});
describe(@"The user", ^{

});

SPEC_END

