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
    AlgorithmMain * sut = [AlgorithmMain new];
    
    context(@"when there are less than two guests", ^{
        it(@"should notify that it's required at least one guest more", ^{
            [[theBlock(^{
                [sut getHourProposal: @[@10]];
            }) should] raiseWithName:@"InvalidParameters" reason:@"Required at least two guests"];
        });
    });
    
    context(@"when there are more than one guests", ^{
        context(@"when the hours are between 7 a.m. and 9 p.m.", ^{
            it(@"should return the same hours", ^{
                NSArray * proposedHours = [sut getHourProposal: @[@10, @20]];
                [[proposedHours should] equal: @[@10, @20]];
            });
            
            context(@"when the hours are: 9 a.m., 6 p.m.", ^{
                it(@"should return the same hours", ^{
                    NSArray * proposedHours = [sut getHourProposal: @[@9, @18]];
                    [[proposedHours should] equal:@[@9, @18]];
                });
            });
            
            context(@"when the hours are: 5 a.m., 24 p.m.", ^{
                it(@"should return diferents hours", ^{
                    NSArray * proposedHours = [sut getHourProposal: @[@5, @24]];
                    [[proposedHours shouldNot] equal:@[@5, @24]];
                });
            });
            
            context(@"when the hours are: 14 a.m., 16 p.m., 7 a.m., 9 a.m.", ^{
                it(@"should return the same hours", ^{
                    NSArray * proposedHours = [sut getHourProposal: @[@14, @16, @7, @9]];
                    [[proposedHours should] equal:@[@14, @16, @7, @9]];
                });
            });
            
            context(@"when the hours are: 14 a.m., 16 p.m., 6 a.m., 9 a.m.", ^{
                it(@"should return diferents hours", ^{
                    NSArray * proposedHours = [sut getHourProposal: @[@14, @16, @6, @9]];
                    [[proposedHours shouldNot] equal:@[@14, @16, @6, @9]];
                });
            });
        });
        
        context(@"when at least one hour is outside the range between 7 a.m. and 9 p.m.", ^{
            it(@"should not return the same hours", ^{
                NSArray * proposedHours = [sut getHourProposal: @[@6, @20]];
                [[proposedHours shouldNot] equal: @[@6, @20]];
            });
            
            context(@"when the hours are: 11 p.m., 7 a.m.", ^{
                it(@"should return diferents hours", ^{
                    NSArray * proposedHours = [sut getHourProposal: @[@23, @7]];
                    [[proposedHours should] equal:@[@13, @21]];
                });
            });
            
            context(@"when the hours are: 5 a.m., 24 p.m., 9 a.m.", ^{
                it(@"should return diferents hours", ^{
                    NSArray * proposedHours = [sut getHourProposal: @[@5, @24, @9]];
                    [[proposedHours should] equal:@[@17, @12, @21]];
                });
            });
            
            context(@"when the hours are: 2 p.m., 4 p.m., 11 p.m., 7 a.m., 9 a.m.", ^{
                it(@"should return the same hours", ^{
                    NSArray * proposedHours = [sut getHourProposal: @[@14, @16, @23, @7, @9]];
                    [[proposedHours should] equal: @[@14, @16, @23, @7, @9]];
                });
            });
            
            context(@"when the hours are: 11 a.m., 13 a.m., 20 p.m., 1 a.m.", ^{
                it(@"should return the same hours", ^{
                    NSArray * proposedHours = [sut getHourProposal: @[@11, @13, @20, @1]];
                    [[proposedHours should] equal: @[@7, @9, @16, @21]];
                });
            });
            
        });
        
        context(@"when all the hours are outside the range between 7 a.m. and 9 p.m", ^{
            context(@"when the hours are: 5 a.m., 24 p.m.", ^{
                it(@"should return diferents hours", ^{
                    NSArray * proposedHours = [sut getHourProposal: @[@5, @24]];
                    [[proposedHours should] equal:@[@14, @9]];
                });
            });
            
            context(@"when the hours are: 5 a.m., 24 p.m., 9 a.m.", ^{
                it(@"should return diferents hours", ^{
                    NSArray * proposedHours = [sut getHourProposal: @[@5, @24, @9]];
                    [[proposedHours shouldNot] equal:@[@14, @9, @18]];
                });
            });
            
            context(@"when the hours are: 6 a.m., 9 p.m.", ^{
                it(@"should return diferents hours", ^{
                    NSArray * proposedHours = [sut getHourProposal: @[@6, @18]];
                    [[proposedHours shouldNot] equal:@[@15, @3]];
                });
            });
        });
    });
});

SPEC_END

