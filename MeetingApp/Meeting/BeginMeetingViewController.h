//
//  MeetingBeginViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 12/28/15.
//  Copyright © 2015 Estefania Chavez Guardado. All rights reserved.
//
/* MeetingBeginViewController_h */

#import "ModelTableViewController.h"

#import "UIScrollView+EmptyDataSet.h"
#import <UIKit/UIKit.h>

@interface BeginMeetingViewController : ModelTableViewController <UITextFieldDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property(nonatomic, weak) IBOutlet UIButton * nextButton;

@property (strong, nonatomic) IBOutlet UITextField *nameMeeting;
@property (strong, nonatomic) IBOutlet UITextField *nameGuest;
@property (strong, nonatomic) IBOutlet UIButton *search;

@property(strong) NSMutableArray *dataModel;
@property(strong) NSDictionary *dataModelCountries;
@property(strong) NSDictionary *dataModelUser;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)searchContacts:(id)sender;


@end