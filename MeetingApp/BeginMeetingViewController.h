//
//  MeetingBeginViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 12/28/15.
//  Copyright © 2015 Estefania Chavez Guardado. All rights reserved.
//
/* MeetingBeginViewController_h */

#import <UIKit/UIKit.h>

@interface BeginMeetingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@property(nonatomic, weak) IBOutlet UIButton * nextButton;
- (IBAction)cancelButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *nameMeeting;
@property (strong, nonatomic) IBOutlet UITextField *nameGuest;

@end