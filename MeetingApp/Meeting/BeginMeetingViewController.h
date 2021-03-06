//
//  MeetingBeginViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 12/28/15.
//  Copyright © 2015 Estefania Chavez Guardado. All rights reserved.
//
/* MeetingBeginViewController_h */

#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>

#import "UIScrollView+EmptyDataSet.h"
#import "Meeting.h"
#import "ModelTableViewController.h"
#import "IGuestInformationDelegate.h"
#import "ArrayOfCountries.h"
#import "IMeetingDelegate.h"
#import "IMeetingDatasource.h"
#import "IUserDatasource.h"
#import "IUserDelegate.h"

#import "ContactAddress.h"
#import "IContactInformation.h"

@interface BeginMeetingViewController : ModelTableViewController <UITextFieldDelegate,
DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, IGuestInformationDelegate, SWTableViewCellDelegate, IContactInformation>

@property (strong) ContactAddress * pickerAddress;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UITextField *nameMeeting;
@property (strong, nonatomic) IBOutlet UITextField *emailGuest;
@property (strong, nonatomic) IBOutlet UIImageView *addContactAddress;

@property (weak) id<IMeetingDelegate, IMeetingDatasource> meetingbusiness;
@property (weak) id<IUserDelegate, IUserDatasource> userbusiness;

@property(nonatomic, strong) MutableMeeting * currentMeeting;
@property(nonatomic, strong) MutableMeeting * currentMeetingToUserDetail;

@property (strong) NSMutableArray *listOfGuests;
@property (strong) NSIndexPath *indexPathGuestSelected;

@property (strong) NSArray * modelCountries;
@property (nonatomic, strong) ArrayOfCountries *arrayCountries;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)nextPressed:(id)sender;

@end