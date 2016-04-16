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
#import "Meeting.h"
#import "MBProgressHUD.h"

@interface MeetingDetailViewController ()

//@property (weak, nonatomic) IBOutlet UIButton *pushNotification;
//@property (weak, nonatomic) IBOutlet UIButton *emailNotification;
@property (weak, nonatomic) IBOutlet UIButton *reminderNotification;
@property (weak, nonatomic) IBOutlet UIButton *calendarNotification;

@end

@implementation MeetingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    hud.color = [UIColor lightGrayColor];
    
    self.meetingbusiness = [[MainAssembly defaultAssembly] meetingBusinessController];
    self.userbusiness = [[MainAssembly defaultAssembly] userBusinessController];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.allowsSelection = NO;
    
    [self.calendarNotification addTarget:self action:@selector(buttonChangeColorWhenPressed:) forControlEvents:UIControlEventTouchDown];
    [self.reminderNotification addTarget:self action:@selector(buttonChangeColorWhenPressed:) forControlEvents:UIControlEventTouchDown];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: YES];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self setDateInLabels];
    
    [self.meetingbusiness updateMeetingsWithCallback:^(id<IMeetingDatasource> handler) {
        NSDictionary * meetingDetail = [handler getMeetingDetail: self.currentMeeting];
        
        self.detailMeeting = [NSDictionary dictionaryWithDictionary: meetingDetail[@"detail"]];
        self.guests = [NSArray arrayWithArray: meetingDetail[@"guests"]];
        self.notifications =
        [NSMutableDictionary dictionaryWithDictionary: self.detailMeeting[@"notifications"]];
        
        [self updateState:self.notifications];
    }];
    
    [self.userbusiness updateUserWithCallback:^(id<IUserDatasource>handler) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        [self updateViewModel];
        [self.tableView reloadData];
    }];
}

- (void) setDateInLabels{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss ZZZZ"];
    NSDate *dateFromString = [dateFormatter dateFromString:self.currentMeeting[@"date"]];
    
    [dateFormatter setDateFormat:@"dd-MMMM-yyyy"];
    [self.dateOfMeeting setText:[dateFormatter stringFromDate:dateFromString]];
    
    [dateFormatter setDateFormat:@"HH:mm:ss ZZZZ"];
    [self.timeOfMeeting setText:[dateFormatter stringFromDate:dateFromString]];
}

- (void) updateState: (NSDictionary *) notifications{
    
    if ([notifications[@"calendar"][@"state"]  isEqual: @NO]){
        self.calendarNotification.selected = NO;
        [self buttonChangeColorWhenPressed:self.calendarNotification];
    } else if ([notifications[@"calendar"][@"state"]  isEqual: @YES]){
        [self verifyEventHasNotDeletedOfCalendar: notifications[@"calendar"][@"idEvent"]];
    }
    
    if ([notifications[@"reminder"]  isEqual: @NO]){
        self.reminderNotification.selected = NO;
        [self buttonChangeColorWhenPressed:self.reminderNotification];
    } else if ([notifications[@"reminder"]  isEqual: @YES]){
        [self verifyReminderEventHasNotDeletedInApp];
    }
    
}

- (void) verifyEventHasNotDeletedOfCalendar: (NSString *) eventId{
    EKEventStore* store = [EKEventStore new];
    EKEvent *identifyEvent = (EKEvent *)[store calendarItemWithIdentifier:eventId];
    if (identifyEvent == nil) {
        [self.notifications setValue: @{@"state" : @NO,
                                        @"idEvent" : @""}
                              forKey:@"calendar"];
        self.calendarNotification.selected = NO;
        [self buttonChangeColorWhenPressed:self.calendarNotification];
        [self updateDetailChangedInBusinessController];
        [self alertStatusNotification:@"Calendar Notifaction"
                                 with:@"You have removed the event of the meeting from the Calendar."];
    } else {
        self.calendarNotification.selected = YES;
        [self buttonChangeColorWhenPressed:self.calendarNotification];
    }
}

// TODO: Extract to handler
- (void) verifyReminderEventHasNotDeletedInApp {
    EKEventStore *eventStore = [EKEventStore new];
    
    NSArray *calendars = [NSArray arrayWithObject:[eventStore defaultCalendarForNewReminders]];
    
    NSPredicate *predicate = [eventStore predicateForRemindersInCalendars:calendars];
    __block BOOL existReminder = NO;
    
    [eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders)
     {
         for (EKReminder *reminder  in reminders) {
             if ([reminder.title isEqualToString:self.detailMeeting[@"name"]]){
                 existReminder = YES;
                 break;
             }
         }
         
         dispatch_async(dispatch_get_main_queue(), ^{
             if (existReminder == YES) {
                 self.reminderNotification.selected = YES;
                 [self buttonChangeColorWhenPressed:self.reminderNotification];
             } else{
                 self.reminderNotification.selected = NO;
                 [self.notifications setValue:@NO forKey:@"reminder"];
                 [self buttonChangeColorWhenPressed:self.reminderNotification];
                 
                 [self updateDetailChangedInBusinessController];
                 [self alertStatusNotification:@"Reminder Notifaction"
                                          with:@"You have removed the reminder of the meeting from the Reminders."];
             }
         });
     }];
    
}

- (void) updateViewModel {
    NSMutableArray * viewModel = [NSMutableArray array];
    __block NSDictionary * detailUser = [NSDictionary dictionaryWithDictionary:[self.userbusiness getUser]];

    [self.guests enumerateObjectsUsingBlock:^(NSDictionary * guests, NSUInteger idx, BOOL * stop) {
        
        if (![self existUser:detailUser AsGuest:guests]) {
            
            NSMutableDictionary * cellModel = [NSMutableDictionary dictionaryWithDictionary:guests];
            
            [viewModel addObject:@{
                                   @"nib" : @"GuestViewCell",
                                   @"height" : @(70),
                                   @"segue" : @"guestDetail",
                                   @"data":cellModel }];
        }
    }];
    
    self.viewModel = viewModel;
    
    [super updateViewModel];
}

- (BOOL) existUser:(NSDictionary *) userDetail AsGuest:(NSDictionary *) guestDetail {
    BOOL existUser = NO;
    if ([[userDetail valueForKey:@"email"] isEqualToString:[guestDetail valueForKey:@"email"]]) {
        existUser = YES;
    }
    return existUser;
}

-(void)buttonChangeColorWhenPressed:(UIButton *)button{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([button isSelected]) {
            button.backgroundColor = [UIColor colorWithRed:1 green:0.412 blue:0.412 alpha:1];
        }else if (![button isSelected]){
            button.backgroundColor = [UIColor colorWithRed:0.608 green:0.608 blue:0.608 alpha:1];
        }
    });
}

- (IBAction)buttonPressed:(id)sender {
    UIButton *buttonPress = (UIButton *)sender;
    
    if ([buttonPress isEqual:self.calendarNotification]) {
        [self.notifications
         setValue: @{@"state" : [self.notifications[@"calendar"][@"state"] isEqual: @NO] ? @YES : @NO,
                     @"id": self.notifications[@"calendar"][@"idEvent"]} forKey:@"calendar"];
        
        [self notificationCalendar:[self.notifications[@"calendar"][@"state"] isEqual: @NO] ? NO : YES];
        
        if ([self.notifications[@"calendar"][@"state"] isEqual:@NO]) {
            self.calendarNotification.selected = NO;
            [self buttonChangeColorWhenPressed:self.calendarNotification];
            [self alertStatusNotification:@"Calendar Notifaction"
                                     with:@"You have removed the meeting of the Calendar."];
        }
    
    } else if ([buttonPress isEqual:self.reminderNotification]) {
        [self.notifications setValue: [self.notifications[@"reminder"]  isEqual: @NO] ? @YES : @NO
                              forKey: @"reminder"];
        
        [self notificationReminder:self.notifications[@"reminder"]];
        
        if ([self.notifications[@"reminder"] isEqual:@YES]) {
            [self alertStatusNotification:@"Reminder Notifaction"
                                     with:@"You have added the meeting to the Reminders."];
        } else {
            [self alertStatusNotification:@"Reminder Notifaction"
                                     with:@"You have removed the meeting of the Reminders."];
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

- (void) updateDetailChangedInBusinessController{
    NSMutableDictionary *changeDetailMeeting =
    [NSMutableDictionary dictionaryWithDictionary:self.detailMeeting];
    
    if (![changeDetailMeeting[@"notifications"] isEqual:self.notifications]) {
        [changeDetailMeeting removeObjectForKey:@"notifications"];
        [changeDetailMeeting setValue:self.notifications forKey:@"notifications"];
        
        [self.meetingbusiness updateNotifications:changeDetailMeeting InMeeting: self.currentMeeting];
    }
}

- (void) notificationReminder: (BOOL) state {
    EKEventStore *eventStore = [EKEventStore new];
    
    if (state == NO) {
        NSArray *calendars = [NSArray arrayWithObject:[eventStore defaultCalendarForNewReminders]];
        
        NSPredicate *predicate = [eventStore predicateForRemindersInCalendars:calendars];
        
        [eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders)
         {
             for (EKReminder *reminder  in reminders){
                 if ([reminder.title isEqualToString:self.detailMeeting[@"name"]]){
                     [eventStore removeReminder:reminder commit:YES error:nil];
                     [self updateDetailChangedInBusinessController];
                 }
             }
         }];
        
    }
    else{
        
        EKReminder *reminder = [EKReminder reminderWithEventStore:eventStore];
        
        reminder.title = self.detailMeeting[@"name"];
        
        reminder.alarms = [NSArray arrayWithObject:[EKAlarm alarmWithAbsoluteDate:[NSDate date]]];
        
        reminder.calendar = [eventStore defaultCalendarForNewReminders];
        
        NSError *error = nil;
        
        [eventStore saveReminder:reminder commit:YES error:&error];
        [self updateDetailChangedInBusinessController];

    }
}

- (void) notificationCalendar: (BOOL) state {
    EKEventStore *eventStore = [EKEventStore new];
    EKEvent *events = [EKEvent eventWithEventStore:eventStore];
    
    if (state == NO) {
        EKEventStore* store = [[EKEventStore alloc] init];
        EKEvent *eventToRemove = (EKEvent *)[store calendarItemWithIdentifier:self.savedEventId];
        if (eventToRemove != nil) {
            NSError* error = nil;
            [store removeEvent:eventToRemove span:EKSpanThisEvent error:&error];
            [self.notifications setValue: @{@"state" : @NO,
                                            @"idEvent" : @""}
                                  forKey:@"calendar"];
            [self updateDetailChangedInBusinessController];
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
             {case EKEventEditViewActionSaved:
                 [self.notifications setValue: @{@"state" : @YES,
                                                 @"idEvent" : self.savedEventId}
                                       forKey:@"calendar"];
                 self.calendarNotification.selected = YES;
                 [self buttonChangeColorWhenPressed:self.calendarNotification];
                 [self updateDetailChangedInBusinessController];
                 break;}
                 
             {case EKEventEditViewActionCanceled:
                 self.savedEventId = @"";
                 [self.notifications setValue: @{@"state" : @NO,
                                                 @"idEvent" : self.savedEventId}
                                       forKey:@"calendar"];
                 [self updateDetailChangedInBusinessController];
                 break;}
                 
             {default:
                 break;}
         }
     }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
