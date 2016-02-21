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
    context(@"when there are less than two guests", ^{
        it(@"should notify that it's required at least one guest more", ^{
            AlgorithmMain * sut = [AlgorithmMain new];
            
            [[theBlock(^{
                [sut getHourProposal: @[@10]];
            }) should] raiseWithName:@"InvalidParameters" reason:@"Required at least two guests"];
        });
    });
    
    context(@"when there are more than one guests", ^{
        context(@"when the hours are between 7 a.m. and 9 p.m.", ^{
            it(@"should return the same hours", ^{
                AlgorithmMain * sut = [AlgorithmMain new];
                NSArray * proposedHours = [sut getHourProposal: @[@10, @20]];
                [[proposedHours should] equal: @[@10, @20]];
            });
        });
    });
});

SPEC_END

