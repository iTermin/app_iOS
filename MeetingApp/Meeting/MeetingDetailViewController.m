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

    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.allowsSelection = NO;
    
    [self.calendarNotification addTarget:self action:@selector(buttonChangeColorWhenPressed:) forControlEvents:UIControlEventTouchDown];
    [self.reminderNotification addTarget:self action:@selector(buttonChangeColorWhenPressed:) forControlEvents:UIControlEventTouchDown];
    
    [self updateViewModel];
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

        [MBProgressHUD hideHUDForView:self.view animated:YES];

        [self updateState:self.notifications];
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
    
    if ([notifications[@"calendar"]  isEqual: @NO]){
        self.calendarNotification.selected = NO;
        [self buttonChangeColorWhenPressed:self.calendarNotification];
    } else if ([notifications[@"calendar"]  isEqual: @YES]){
        [self verifyEventHasNotDeletedOfCalendar];
    }
    
    if ([notifications[@"reminder"]  isEqual: @NO]){
        self.reminderNotification.selected = NO;
        [self buttonChangeColorWhenPressed:self.reminderNotification];
    } else if ([notifications[@"reminder"]  isEqual: @YES]){
        [self verifyReminderEventHasNotDeletedInApp];
    }
    
}

- (void) verifyEventHasNotDeletedOfCalendar{

}

// TODO: Extract to handler
- (void) verifyReminderEventHasNotDeletedInApp {
    EKEventStore *eventStore = [EKEventStore new];
    
    NSArray *calendars = [NSArray arrayWithObject:[eventStore defaultCalendarForNewReminders]];
    
    NSPredicate *predicate = [eventStore predicateForRemindersInCalendars:calendars];
    __block BOOL existReminder = NO;
    
    [eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders)
     {
         for (EKReminder *reminder  in reminders)
             if ([reminder.title isEqualToString:self.detailMeeting[@"name"]]){
                 existReminder = YES;
                 NSLog(@"%@", reminder.title);
             }
         
         if (existReminder == YES) {
             self.reminderNotification.selected = YES;
             [self buttonChangeColorWhenPressed:self.reminderNotification];
         } else{
             self.reminderNotification.selected = NO;
             [self.notifications setValue:@NO forKey:@"reminder"];
             [self buttonChangeColorWhenPressed:self.reminderNotification];
             
             [self updateDetailChangedInBusinessController];
             [self alertStatusNotification:@"Reminder Notifaction"
                                      with:@"You have removed the reminder of the meeting directly in Reminders."];
         }
     }];
    
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
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([button isSelected]) {
            button.selected = NO;
            button.backgroundColor = [UIColor colorWithRed:1 green:0.412 blue:0.412 alpha:1];
        }else if (![button isSelected]){
            button.selected = YES;
            button.backgroundColor = [UIColor colorWithRed:0.608 green:0.608 blue:0.608 alpha:1];
        }
    });
}

- (IBAction)buttonPressed:(id)sender {
    UIButton *buttonPress = (UIButton *)sender;
    BOOL statusSelected = buttonPress.selected;
    
    if (statusSelected == YES) {

        if (buttonPress == _calendarNotification)
            [self refreshStatus:statusSelected OfNotification:_calendarNotification];

        else if (buttonPress == _reminderNotification) {
            [self refreshStatus:statusSelected OfNotification:_reminderNotification];
            [self alertStatusNotification:@"Reminder Notifaction"
                                     with:@"You have added the meeting to the Reminders."];
        }
    } else {
        
        if (buttonPress == _calendarNotification) {
            [self refreshStatus:statusSelected OfNotification:_calendarNotification];
            [self alertStatusNotification:@"Calendar Notifaction"
                                     with:@"You have removed the meeting of the Calendar."];
        
        }

        else if (buttonPress == _reminderNotification) {
            [self refreshStatus:statusSelected OfNotification:_reminderNotification];
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

- (void) refreshStatus: (BOOL) stateButton OfNotification: (UIButton *) buttonPressed{
    NSString * nameOfButton = [NSString new];
    
    if ([buttonPressed isEqual:self.calendarNotification]) {
        nameOfButton = @"calendar";
        [self.notifications setValue:@{ @"state": stateButton == NO ? @NO : @YES,
                                        @"idEvent": self.savedEventId } forKey:@"calendar"];
    }
    else if ([buttonPressed isEqual:self.reminderNotification]) {
        nameOfButton = @"reminder";
        [self.notifications setValue:stateButton == NO ? @NO : @YES forKey:@"reminder"];
    }
    
    [self performAction:nameOfButton with:stateButton];
    
    //[self.notifications setValue: stateButton == NO ? @NO : @YES forKey:nameOfButton];
    
    [self updateDetailChangedInBusinessController];
}

- (void) updateDetailChangedInBusinessController{
    NSMutableDictionary *changeDetailMeeting =
    [NSMutableDictionary dictionaryWithDictionary:self.detailMeeting];
    
    [changeDetailMeeting removeObjectForKey:@"notifications"];
    [changeDetailMeeting setValue:self.notifications forKey:@"notifications"];
    
    self.detailMeeting = [NSDictionary dictionaryWithDictionary:changeDetailMeeting];
    
    [self.meetingbusiness updateDetail:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        self.detailMeeting, @"detail",
                                        self.guests, @"guests", nil]];
}

- (void) performAction: (NSString*) notification with: (BOOL) stateNotification {
    
    if ([notification isEqualToString:@"reminder"]){
        if ([self.reminderNotification isSelected])
            [self notificationReminder:stateNotification];
    
        else
            [self notificationReminder:stateNotification];
    }
    
    else if ([notification isEqualToString:@"calendar"]){
        if ([self.calendarNotification isSelected])
            [self notificationCalendar:stateNotification];

        else
            [self notificationCalendar:stateNotification];
    }

}

- (void) notificationReminder: (BOOL) state {
    EKEventStore *eventStore = [EKEventStore new];
    
    if (state == NO) {
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
    
    if (state == NO) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
