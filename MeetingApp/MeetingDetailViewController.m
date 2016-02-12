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
    
    self.guests = @[
                    @{
                        @"name": @"Luis Alejandro Rangel",
                        @"codePhone" : @"+52",
                        @"email": @"email@correo.mx",
                        @"photo": @"fondo",
                        @"codeCountry" : @"MX"
                        },
                    @{
                        @"name": @"Jesus Cagide",
                        @"codePhone" : @"+1",
                        @"email": @"email@correo.mx",
                        @"photo": @"",
                        @"codeCountry" : @"US"
                        }
                    ];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.pushNotification addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.calendarNotification addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.reminderNotification addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.emailNotification addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    
    [self updateViewModel];
}

- (void) updateViewModel {
    NSMutableArray * viewModel = [NSMutableArray array];
    [self.guests enumerateObjectsUsingBlock:^(NSDictionary * guests, NSUInteger idx, BOOL * stop) {
        
        NSMutableDictionary * cellModel = [NSMutableDictionary dictionaryWithDictionary:guests];
        
        [viewModel addObject:@{
                               @"nib" : @"GuestViewCell",
                               @"height" : @(60),
                               @"segue" : @"guestDetail",
                               @"data":cellModel }];
    }];
    
    self.viewModel = viewModel;
    
    [super updateViewModel];
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

- (IBAction)deleteMeetingPressed:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Meeting"
                                                                   message:@"Are you sure you want to delete this meeting? This meeting will be deleted for all."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action){
                                                       //Do some thing here
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action){
                                                       //Do some thing here
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    [alert addAction:delete];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.timeOfMeeting setText: self.currentMeeting[@"date"]];
}

- (void) performSegue:(NSIndexPath *)indexPath{
    NSDictionary * selectedMeeting = self.guests[indexPath.row];
    NSDictionary * cellModel = self.viewModel[indexPath.row];
    NSString * segueToPerform = cellModel[@"segue"];
    if(segueToPerform) {
        [self performSegueWithIdentifier:segueToPerform
                                  sender: selectedMeeting];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary *)sender {
    GuestDetailViewController * guestDetailViewController = (GuestDetailViewController *)segue.destinationViewController;
    [guestDetailViewController setTitle:sender[@"name"]];
    [guestDetailViewController setCurrentGuest: sender];
}

@end
