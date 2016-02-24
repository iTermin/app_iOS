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
                it(@"should not return the same hours", ^{
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
                it(@"should not return the same hours", ^{
                    NSArray * proposedHours = [sut getHourProposal: @[@14, @16, @6, @9]];
                    [[proposedHours shouldNot] equal:@[@14, @16, @6, @9]];
                });
            });
        });
        
        context(@"when at least one hour is outside the range between 7 a.m. and 9 p.m.", ^{
            context(@"when the hours are: 6 a.m., 8 p.m.", ^{
                it(@"should not return the same hours", ^{
                    NSArray * proposedHours = [sut getHourProposal: @[@6, @20]];
                    [[proposedHours shouldNot] equal: @[@6, @20]];
                });
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
                it(@"should return diferents hours", ^{
                    NSArray * proposedHours = [sut getHourProposal: @[@11, @13, @20, @1]];
                    [[proposedHours should] equal: @[@7, @9, @16, @21]];
                });
            });
            
            context(@"when the hours are: 4 p.m., 8 p.m., 11 p.m., 7 a.m.", ^{
                it(@"should return diferents hours", ^{
                    NSArray * proposedHours = [sut getHourProposal: @[@16, @20, @23, @7]];
                    [[proposedHours shouldNot] equal: @[@17, @21, @24, @8]];
                });
            });
            
            context(@"when the hours are: 4 a.m., 7 a.m., 12 p.m., 1 p.m., 2 p.m., 5 p.m., 9 p.m., 11 p.m., 12 a.m.", ^{
                it(@"should return diferents hours", ^{
                    NSArray * proposedHours = [sut getHourProposal: @[@4, @7, @12, @13, @14, @17, @21, @23, @24]];
                    [[proposedHours shouldNot] equal: @[@14, @17, @22, @23, @24, @3, @7, @9, @10]];
                });
            });
            
            context(@"when the hours are: 1 a.m., 6 a.m., 12 p.m., 5 a.m., 10 a.m., 8 p.m., 10 p.m., 9 p.m., 7 a.m.", ^{
                it(@"should the same hours", ^{
                    NSArray * proposedHours = [sut getHourProposal: @[@1, @6, @12, @5, @10, @20, @22, @21, @7]];
                    [[proposedHours should] equal: @[@1, @6, @12, @5, @10, @20, @22, @21, @7]];
                });
            });
            
            context(@"when the hours are: 7 a.m., 7 a.m., 7 a.m.", ^{
                it(@"should the same hours", ^{
                    NSArray * proposedHours = [sut getHourProposal: @[@7, @7, @7]];
                    [[proposedHours should] equal: @[@7, @7, @7]];
                });
            });
            
            context(@"when the hours are: 9 p.m., 9 p.m., 9 p.m.", ^{
                it(@"should the same hours", ^{
                    NSArray * proposedHours = [sut getHourProposal: @[@21, @21, @21]];
                    [[proposedHours should] equal: @[@21, @21, @21]];
                });
            });
            
            context(@"when the hours are: 7 a.m., 9 p.m., 12 a.m.", ^{
                it(@"should the same hours", ^{
                    NSArray * proposedHours = [sut getHourProposal: @[@7, @21, @24]];
                    [[proposedHours should] equal: @[@7, @21, @24]];
                });
            });
            
        });
        
        context(@"when all the hours are outside the range between 7 a.m. and 9 p.m", ^{
            context(@"when the hours are: 7 a.m., 21 p.m.", ^{
                it(@"should return the same hours", ^{
                    NSArray * proposedHours = [sut getHourProposal: @[@7, @21]];
                    [[proposedHours should] equal:@[@7, @21]];
                });
            });
            
            context(@"when the hours are: 12 a.m., 12 a.m., 12 a.m.", ^{
                it(@"should the same hours", ^{
                    NSArray * proposedHours = [sut getHourProposal: @[@24, @24, @24]];
                    [[proposedHours should] equal: @[@9, @9, @9]];
                });
            });
            
            context(@"when the hours are: 5 a.m., 24 p.m.", ^{
                it(@"should return diferents hours", ^{
                    NSArray * proposedHours = [sut getHourProposal: @[@5, @24]];
                    [[proposedHours should] equal:@[@14, @9]];
                });
            });
            
            context(@"when the hours are: 22 p.m., 23 p.m., 24 p.m., 1 a.m., 2 a.m., 3 a.m., 4 a.m., 5 a.m., 6 a.m.", ^{
                it(@"should return diferents hours", ^{
                    NSArray * proposedHours = [sut getHourProposal: @[@22, @23, @24, @1, @2, @3, @4, @5, @6]];
                    [[proposedHours should] equal:@[@7, @8, @9, @10, @11, @12, @13, @14, @15]];
                });
            });
            
            context(@"when at least one hour is outside the range between 7 a.m. and 9 p.m.", ^{
                
                context(@"when the hours are: 5 a.m., 24 p.m., 9 a.m.", ^{
                    it(@"should not return the same hours", ^{
                        NSArray * proposedHours = [sut getHourProposal: @[@5, @24, @9]];
                        [[proposedHours shouldNot] equal:@[@14, @9, @18]];
                    });
                });
                
                context(@"when the hours are: 6 a.m., 6 p.m.", ^{
                    it(@"should not return the same hours", ^{
                        NSArray * proposedHours = [sut getHourProposal: @[@6, @18]];
                        [[proposedHours shouldNot] equal:@[@15, @3]];
                    });
                });
            });
        });
    });
});

SPEC_END

