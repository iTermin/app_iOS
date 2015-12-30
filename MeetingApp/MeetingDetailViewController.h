//
//  MeetingDetailViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 12/28/15.
//  Copyright © 2015 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingDetailViewController : UIViewController

@property(nonatomic, strong) NSDictionary * currentMeeting;

@property(nonatomic, weak) IBOutlet UILabel * dateOfMeeting;
@property(nonatomic, weak) IBOutlet UILabel * timeOfMeeting;

@property (strong, nonatomic) IBOutlet UIView *pushNotification;
@property (strong, nonatomic) IBOutlet UIView *reminderNotification;
@property (strong, nonatomic) IBOutlet UIView *emailNotification;
@property (strong, nonatomic) IBOutlet UIView *calendarNotification;


- (IBAction)pushButtonPress:(id)sender;
- (IBAction)reminderNotification:(id)sender;
- (IBAction)emailNotification:(id)sender;
- (IBAction)calendarNotification:(id)sender;


@end
