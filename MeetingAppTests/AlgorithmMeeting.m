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
describe(@"AlgorithmMeeting", ^{
    
    __block NSMutableArray *guestTimes = [[NSMutableArray alloc] init];
    
    context(@"when get date of the Guest", ^{
        
        context(@"when exist time zone of guest", ^{
        
            context(@"when time zone guest is equal to user", ^{
            
                
            });
            
        });
        
        context(@"when doesn´t have time zone the guest", ^{
            
            it(@"used the time zone of the user", ^{
            
            });
        
        });
        
    });
    
    context(@"when will be created Meeting", ^{
        
        it(@"is not empty", ^{
            [[guestTimes shouldNot] beEmpty];
        });
    });
    
});
describe(@"The user", ^{

});

SPEC_END

