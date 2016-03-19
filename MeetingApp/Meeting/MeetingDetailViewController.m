//
//  MeetingDetailViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 12/28/15.
//  Copyright © 2015 Estefania Chavez Guardado. All rights reserved.
//

#import <EventKit/EventKit.h>

#import "MeetingDetailViewController.h"
#import "MainAssembly.h"

@interface MeetingDetailViewController ()

{
    BOOL unselectedReminder;
    BOOL unselectedCalendar;
}

@property (weak, nonatomic) IBOutlet UIButton *pushNotification;
@property (weak, nonatomic) IBOutlet UIButton *emailNotification;
@property (weak, nonatomic) IBOutlet UIButton *reminderNotification;
@property (weak, nonatomic) IBOutlet UIButton *calendarNotification;

@end

@implementation MeetingDetailViewController

@synthesize pushNotification;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.detailMeeting = [NSDictionary dictionaryWithDictionary:
                          [[[MainAssembly defaultAssembly] meetingBusinessController]
                   getMeetingDetail: self.currentMeeting][@"detail"]];
    
    self.guests = [NSArray arrayWithArray:
                   [[[MainAssembly defaultAssembly] meetingBusinessController]
                   getMeetingDetail: self.currentMeeting][@"guests"]];
    
    self.notifications = [NSMutableDictionary dictionaryWithDictionary:
                        [[[MainAssembly defaultAssembly] meetingBusinessController]
                         getMeetingDetail: self.currentMeeting][@"notifications"]];

    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.allowsSelection = NO;
    
    [self.pushNotification addTarget:self action:@selector(buttonChangeColorWhenPressed:) forControlEvents:UIControlEventTouchDown];
    [self.calendarNotification addTarget:self action:@selector(buttonChangeColorWhenPressed:) forControlEvents:UIControlEventTouchDown];
    [self.reminderNotification addTarget:self action:@selector(buttonChangeColorWhenPressed:) forControlEvents:UIControlEventTouchDown];
    [self.emailNotification addTarget:self action:@selector(buttonChangeColorWhenPressed:) forControlEvents:UIControlEventTouchDown];
    
    [self updateViewModel];
}

- (void) updateViewModel {
    NSMutableArray * viewModel = [NSMutableArray array];
    [self.guests enumerateObjectsUsingBlock:^(NSDictionary * guests, NSUInteger idx, BOOL * stop) {
        
        NSMutableDictionary * cellModel = [NSMutableDictionary dictionaryWithDictionary:guests];
        
        [viewModel addObject:@{
                               @"nib" : @"GuestViewCell",
                               @"height" : @(70),
                               @"segue" : @"guestDetail",
                               @"data":cellModel }];
    }];
    
    self.viewModel = viewModel;
    
    [super updateViewModel];
}

-(void)buttonChangeColorWhenPressed:(UIButton *)button{
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
    BOOL statusSelected = buttonPress.selected;
    
    if (statusSelected == NO) {
        if (buttonPress == pushNotification) {
            [self refreshStatus:statusSelected OfNotification:pushNotification];
            [self alertStatusNotification:@"Push Notification"
                                     with:@"You have activated the push notifications for send you before the meeting."];
        
        } else if (buttonPress == _calendarNotification) {
            [self refreshStatus:statusSelected OfNotification:_calendarNotification];
        
        } else if (buttonPress == _emailNotification) {
            [self refreshStatus:statusSelected OfNotification:_emailNotification];
            [self alertStatusNotification:@"Email Notification"
                                     with:@"You have activated email notifications for send you before the meeting.."];
        
        } else if (buttonPress == _reminderNotification) {
            [self refreshStatus:statusSelected OfNotification:_reminderNotification];
            [self alertStatusNotification:@"Reminder Notifaction"
                                     with:@"You have added the meeting to the reminders."];
        }
    } else {
        if (buttonPress == pushNotification) {
            [self refreshStatus:statusSelected OfNotification:pushNotification];
            [self alertStatusNotification:@"Push Notification"
                                     with:@"You have deactivated the push notifications."];

        } else if (buttonPress == _calendarNotification) {
            [self refreshStatus:statusSelected OfNotification:_calendarNotification];
            [self alertStatusNotification:@"Calendar Notifaction"
                                     with:@"You have removed the meeting of the calendar."];
        
        } else if (buttonPress == _emailNotification) {
            [self refreshStatus:statusSelected OfNotification:_emailNotification];
            [self alertStatusNotification:@"Email Notifaction"
                                     with:@"You have deactivated email notifications."];
        
        } else if (buttonPress == _reminderNotification) {
            [self refreshStatus:statusSelected OfNotification:_reminderNotification];
            [self alertStatusNotification:@"Reminder Notifaction"
                                     with:@"You have removed the meeting of the calendar."];
        }
    }
    
}

- (void) alertStatusNotification: (NSString *)title with: (NSString*) message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    
    [alert addAction:firstAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) refreshStatus: (BOOL) stateButton OfNotification: (UIButton *) buttonPressed{
    NSString * nameOfButton = [NSString new];
    if ([buttonPressed isEqual:self.pushNotification]) nameOfButton = @"apn";
    else if ([buttonPressed isEqual:self.calendarNotification]) nameOfButton = @"calendar";
    else if ([buttonPressed isEqual:self.reminderNotification]) nameOfButton = @"reminder";
    else if ([buttonPressed isEqual:self.emailNotification]) nameOfButton = @"email";
    
    [self.notifications setValue: stateButton == NO ? @YES : @NO forKey:nameOfButton];
    [self performActionNotification:stateButton];
}

- (void) performActionNotification: (BOOL) stateNotification {
    if ([self.notifications[@"apn"] isEqual: @YES])
        NSLog(@"");
    
    else if ([self.notifications[@"calendar"] isEqual: @YES]){
        [self notificationCalendar:stateNotification];
        unselectedCalendar = YES;
    }
    
    else if ([self.notifications[@"calendar"] isEqual: @NO] && unselectedCalendar == YES)
        [self notificationCalendar:stateNotification];

    else if ([self.notifications[@"reminder"] isEqual: @YES]){
        [self notificationReminder:stateNotification];
        unselectedReminder = YES;
    }
    
    else if ([self.notifications[@"reminder"] isEqual: @NO] && unselectedReminder == YES)
        [self notificationReminder:stateNotification];
    
    else if ([self.notifications[@"email"] isEqual: @YES])
        NSLog(@"");
}

- (void) notificationReminder: (BOOL) state {
    EKEventStore *eventStore = [EKEventStore new];
    
    if (state == YES) {
        NSArray *calendars = [NSArray arrayWithObject:[eventStore defaultCalendarForNewReminders]];
        
        NSPredicate *predicate = [eventStore predicateForRemindersInCalendars:calendars];
        
        [eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders)
         {
             for (EKReminder *reminder  in reminders)
                 if ([reminder.title isEqualToString:self.detailMeeting[@"name"]])
                     [eventStore removeReminder:reminder commit:YES error:nil];
         }];

    }
    else{
        
        EKReminder *reminder = [EKReminder reminderWithEventStore:eventStore];
        
        reminder.title = self.detailMeeting[@"name"];
        
        reminder.alarms = [NSArray arrayWithObject:[EKAlarm alarmWithAbsoluteDate:[NSDate date]]];
        
        reminder.calendar = [eventStore defaultCalendarForNewReminders];
                
        NSError *error = nil;
        
        [eventStore saveReminder:reminder commit:YES error:&error];
    }
}

- (void) notificationCalendar: (BOOL) state {
    EKEventStore *eventStore = [EKEventStore new];
    EKEvent *events = [EKEvent eventWithEventStore:eventStore];
    
    if (state == YES) {
        EKEventStore* store = [[EKEventStore alloc] init];
        EKEvent *eventToRemove = (EKEvent *)[store calendarItemWithIdentifier:self.savedEventId];
        if (eventToRemove != nil) {
            NSError* error = nil;
            [store removeEvent:eventToRemove span:EKSpanThisEvent error:&error];
        }
    }
    else{
        events.title = self.detailMeeting[@"name"];
        events.startDate = [NSDate date];
        events.endDate = [NSDate date];
        events.availability = EKEventAvailabilityFree;
        
        NSError *err;
        [eventStore saveEvent:events span:EKSpanThisEvent error:&err];
        self.savedEventId = [[NSString alloc] initWithFormat:@"%@", events.calendarItemIdentifier];
        
        EKEventEditViewController *editViewController = [[EKEventEditViewController alloc] init];
        editViewController.navigationBar.tintColor = [UIColor redColor];
        editViewController.editViewDelegate = self;
        editViewController.event = events;
        editViewController.eventStore = eventStore;
        [self presentViewController:editViewController animated:YES completion:nil];
    }
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action{

    [self dismissViewControllerAnimated:NO completion:^
     {
         switch (action)
         {
             {case EKEventEditViewActionCanceled:
                 self.savedEventId = @"";
                 [self buttonChangeColorWhenPressed:self.calendarNotification];
                 break;}
                 
             {default:
                 break;}
         }
     }];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
