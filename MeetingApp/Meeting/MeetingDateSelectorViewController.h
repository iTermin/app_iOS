//
//  MeetingDateSelectorViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/17/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArrayOfCountries.h"
#import "IMeetingDateSelectorDelegate.h"
#import "IMeetingDelegate.h"
#import "IMeetingDatasource.h"
#import "IUserDelegate.h"
#import "IUserDatasource.h"
#import "Meeting.h"
#import "AlgorithmMain.h"

@interface MeetingDateSelectorViewController : UITableViewController <IMeetingDateSelectorDelegate>

@property(nonatomic, strong) MutableMeeting * currentMeeting;
@property(nonatomic, strong) MutableMeeting * currentMeetingToUserDetail;

@property(strong) NSArray *viewModel;

@property(nonatomic, strong) NSArray * guestsOfMeeting;
@property (nonatomic, strong) ArrayOfCountries *arrayCountries;
@property (strong) NSArray * modelCountries;
@property (strong) NSDictionary * userInformation;

@property (nonatomic, strong) NSDate * startDate;
@property (nonatomic, strong) NSDate * endDate;

@property (strong) NSDate * dateCurrent;

@property (strong) NSMutableArray * hoursArrayCurrent;
@property (strong) NSMutableArray * hoursArrayAlgorithm;

@property (weak) id<IMeetingDelegate, IMeetingDatasource> meetingbusiness;
@property (weak) id<IUserDelegate, IUserDatasource> userbusiness;

@property (strong) AlgorithmMain * algoritmClass;

- (IBAction)sharePressed:(id)sender;
- (IBAction)trashPressed:(id)sender;
- (IBAction)doneMeetingPressed:(id)sender;

@end
