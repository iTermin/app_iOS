//
//  MeetingDetailViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 12/28/15.
//  Copyright © 2015 Estefania Chavez Guardado. All rights reserved.
//

#import "MeetingDetailViewController.h"

@interface MeetingDetailViewController ()

@end

@implementation MeetingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self.timeOfMeeting setText: self.currentMeeting[@"date"]];
}

- (IBAction)pushButtonPress:(id)sender {
    NSLog(@"Push Notification");
}

- (IBAction)reminderNotification:(id)sender{
    NSLog(@"Reminder Notification");
}

- (IBAction)emailNotification:(id)sender{
    NSLog(@"Email Notification");
}

- (IBAction)calendarNotification:(id)sender{
    NSLog(@"Calendar Notification");
}

@end
