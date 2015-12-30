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
    
    self.guests = @[
                      @{
                          @"active" : @(true),
                          @"date" : @"2015-12-11",
                          @"meetingId" : @"m1",
                          @"name" : @"Meeting 1"
                          },
                      @{
                          @"active" : @(true),
                          @"date" : @"2015-11-15",
                          @"meetingId" : @"m2",
                          @"name" : @"Meeting 2"
                          }
                      ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self.timeOfMeeting setText: self.currentMeeting[@"date"]];
}

- (IBAction)pushButtonPressed:(id)sender {
    NSLog(@"Push Notification");
}

- (IBAction)reminderNotificationPressed:(id)sender{
    NSLog(@"Reminder Notification");
}

- (IBAction)emailNotificationPressed:(id)sender{
    NSLog(@"Email Notification");
}

- (IBAction)calendarNotificationPressed:(id)sender{
    NSLog(@"Calendar Notification");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.guests count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"IDENTIFIER"];
    cell.textLabel.font = [UIFont fontWithName:@"BodoniSvtyTwoITCTT-Bold" size:15];
    cell.detailTextLabel.font = [UIFont fontWithName:@"BodoniSvtyTwoITCTT-Book" size:11];
    [[cell textLabel] setText: self.guests[indexPath.row][@"name"]];
    [[cell detailTextLabel] setText: self.guests[indexPath.row][@"date"] ];
    [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

@end
