//
//  MeetingBeginViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 12/28/15.
//  Copyright © 2015 Estefania Chavez Guardado. All rights reserved.
//
/* MeetingBeginViewController_h */

#import <UIKit/UIKit.h>

@interface BeginMeetingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property(nonatomic, weak) IBOutlet UIButton * nextButton;

@property (strong, nonatomic) IBOutlet UITextField *nameMeeting;
@property (strong, nonatomic) IBOutlet UITextField *nameGuest;
@property (strong, nonatomic) IBOutlet UIButton *search;
@property (strong, nonatomic) IBOutlet UITableView *guestsTableView;

@property(strong) NSDictionary *dataModel;
@property(strong) NSArray *viewModel;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)searchContacts:(id)sender;
- (IBAction)inviteGuests:(id)sender;


@end