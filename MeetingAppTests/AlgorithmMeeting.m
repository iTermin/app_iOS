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
});

SPEC_END

