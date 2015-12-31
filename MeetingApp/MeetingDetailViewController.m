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
                          @"email" : @"fachinacg@gmail.com",
                          @"name" : @"Estefania Guardado",
                          @"photo" : @"14241341.png"
                          },
                      @{
                          @"email" : @"xlarsx@gmail.com",
                          @"name" : @"Luis Alejandro Rangel",
                          @"photo" : @"14241323.png"
                          },
                      @{
                          @"email" : @"set311@gmail.com",
                          @"name" : @"Jesus Cagide",
                          @"photo" : @"14298723.png"
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
    [[cell detailTextLabel] setText: self.guests[indexPath.row][@"email"] ];
    [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

@end
