//
//  MeetingDetailViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 12/28/15.
//  Copyright © 2015 Estefania Chavez Guardado. All rights reserved.
//

#import "MeetingDetailViewController.h"
#import "GuestDetailViewController.h"

@interface MeetingDetailViewController ()

@property (weak, nonatomic) IBOutlet UIButton *pushNotification;
@property (weak, nonatomic) IBOutlet UIButton *emailNotification;
@property (weak, nonatomic) IBOutlet UIButton *reminderNotification;
@property (weak, nonatomic) IBOutlet UIButton *calendarNotification;

@end

@implementation MeetingDetailViewController

@synthesize pushNotification;

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

    [self.pushNotification addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.calendarNotification addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.reminderNotification addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.emailNotification addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
}

-(void)buttonTouchDown:(UIButton *)button{
    if (button.selected == YES) {
        button.selected = NO;
        button.backgroundColor = [UIColor colorWithRed:0.608 green:0.608 blue:0.608 alpha:1];
    }else{
        button.selected = YES;
        button.backgroundColor = [UIColor colorWithRed:1 green:0.412 blue:0.412 alpha:1];
    }
}

- (IBAction)buttonPressed:(id)sender {
    UIButton *buttonPress = (UIButton *)sender;
    NSString *title = @"";
    NSString *message = @"";
    BOOL statusSelected = buttonPress.selected;
    
    if (statusSelected == NO) {
        if (buttonPress == pushNotification) {
            title = @"Push Notification";
            message = @"You have activated the push notifications for send you before the meeting.";
        } else if (buttonPress == _calendarNotification) {
            title = @"Calendar Notifaction";
            message = @"You have added the meeting to the calendar.";
        } else if (buttonPress == _emailNotification) {
            title = @"Email Notification";
            message = @"You have activated email notifications for send you before the meeting..";
        } else if (buttonPress == _reminderNotification) {
            title = @"Reminder Notifaction";
            message = @"You have added the meeting to the reminders.";
        }
    } else {
        if (buttonPress == pushNotification) {
            title = @"Push Notification";
            message = @"You have deactivated the push notifications.";
        } else if (buttonPress == _calendarNotification) {
            title = @"Calendar Notifaction";
            message = @"You have removed the meeting of the calendar.";
        } else if (buttonPress == _emailNotification) {
            title = @"Email Notifaction";
            message = @"You have deactivated email notifications.";
        } else if (buttonPress == _reminderNotification) {
            title = @"Reminder Notifaction";
            message = @"You have removed the meeting of the calendar.";
        }
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    
    [alert addAction:firstAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self.timeOfMeeting setText: self.currentMeeting[@"date"]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    NSDictionary * selectedMeeting = self.guests[indexPath.row];
    [self performSegueWithIdentifier:@"guestDetail" sender: selectedMeeting];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary *)sender {
    GuestDetailViewController * guestDetailViewController = (GuestDetailViewController *)segue.destinationViewController;
    [guestDetailViewController setTitle:sender[@"name"]];
    [guestDetailViewController setCurrentGuest: sender];
}

@end
