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
    context(@"when there are not guests", ^{
        it(@"should not return any hour", ^{
            AlgorithmMain * sut = [AlgorithmMain new];
            NSNumber * proposedHour = [sut getHourProposal];
            [[proposedHour should] beNil];
        });
    });
});

SPEC_END

