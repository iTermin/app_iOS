//
//  MeetingDetailViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 12/28/15.
//  Copyright © 2015 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSDictionary * currentMeeting;

@property(nonatomic, weak) IBOutlet UILabel * dateOfMeeting;
@property(nonatomic, weak) IBOutlet UILabel * timeOfMeeting;

@property (strong, nonatomic) IBOutlet UIView *pushNotification;
@property (strong, nonatomic) IBOutlet UIView *reminderNotification;
@property (strong, nonatomic) IBOutlet UIView *emailNotification;
@property (strong, nonatomic) IBOutlet UIView *calendarNotification;

@property(strong) NSArray *guests;


- (IBAction)pushButtonPressed:(id)sender;
- (IBAction)reminderNotificationPressed:(id)sender;
- (IBAction)emailNotificationPressed:(id)sender;
- (IBAction)calendarNotificationPressed:(id)sender;


@end
