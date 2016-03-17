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

@property (weak, nonatomic) IBOutlet UIButton *pushNotification;
@property (weak, nonatomic) IBOutlet UIButton *emailNotification;
@property (weak, nonatomic) IBOutlet UIButton *reminderNotification;
@property (weak, nonatomic) IBOutlet UIButton *calendarNotification;

@end

@implementation MeetingDetailViewController

@synthesize pushNotification;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.savedEventId = [NSString new];
    
    self.detailMeeting = [NSDictionary dictionaryWithDictionary:
                          [[[MainAssembly defaultAssembly] meetingBusinessController]
                   getMeetingDetail: self.currentMeeting][@"detail"]];
    
    self.guests = [NSArray arrayWithArray:
                   [[[MainAssembly defaultAssembly] meetingBusinessController]
                   getMeetingDetail: self.currentMeeting][@"guests"]];
    
    self.notications = [NSMutableDictionary dictionaryWithDictionary:
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
    NSString *title = @"";
    NSString *message = @"";
    BOOL statusSelected = buttonPress.selected;
    
    if (statusSelected == NO) {
        if (buttonPress == pushNotification) {
            [self refreshStatus:statusSelected OfNotification:pushNotification];
            title = @"Push Notification";
            message = @"You have activated the push notifications for send you before the meeting.";
        
        } else if (buttonPress == _calendarNotification) {
            [self refreshStatus:statusSelected OfNotification:_calendarNotification];
        
        } else if (buttonPress == _emailNotification) {
            [self refreshStatus:statusSelected OfNotification:_emailNotification];
            title = @"Email Notification";
            message = @"You have activated email notifications for send you before the meeting..";
        
        } else if (buttonPress == _reminderNotification) {
            [self refreshStatus:statusSelected OfNotification:_reminderNotification];
            title = @"Reminder Notifaction";
            message = @"You have added the meeting to the reminders.";
        }
    } else {
        if (buttonPress == pushNotification) {
            [self refreshStatus:statusSelected OfNotification:pushNotification];
            title = @"Push Notification";
            message = @"You have deactivated the push notifications.";
        
        } else if (buttonPress == _calendarNotification) {
            [self refreshStatus:statusSelected OfNotification:_calendarNotification];
            title = @"Calendar Notifaction";
            message = @"You have removed the meeting of the calendar.";
        
        } else if (buttonPress == _emailNotification) {
            [self refreshStatus:statusSelected OfNotification:_emailNotification];
            title = @"Email Notifaction";
            message = @"You have deactivated email notifications.";
        
        } else if (buttonPress == _reminderNotification) {
            [self refreshStatus:statusSelected OfNotification:_reminderNotification];
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

- (void) refreshStatus: (BOOL) stateButton OfNotification: (UIButton *) buttonPressed{
    NSString * nameOfButton = [NSString new];
    if ([buttonPressed isEqual:self.pushNotification]) nameOfButton = @"apn";
    else if ([buttonPressed isEqual:self.calendarNotification]) nameOfButton = @"calendar";
    else if ([buttonPressed isEqual:self.reminderNotification]) nameOfButton = @"reminder";
    else if ([buttonPressed isEqual:self.emailNotification]) nameOfButton = @"email";
    
    [self.notications setValue: stateButton == NO ? @YES : @NO forKey:nameOfButton];
    [self performActionNotification];
}

- (void) performActionNotification {
    [self.notications enumerateKeysAndObjectsUsingBlock:^(id notification, id state, BOOL *stop) {
        //if ([notification isEqualToString:@"apn"] && [state isEqualToValue:@YES]) NSLog(@"apn");
        
        if ([notification isEqualToString:@"calendar"]
            && [state isEqualToValue:@YES])
            [self notificationCalendar];
        
        else if ([notification isEqualToString:@"reminder"] && [state isEqualToValue:@YES]) NSLog(@"reminder");
        
        else if ([notification isEqualToString:@"email"] && [state isEqualToValue:@YES]) NSLog(@"email");

    }];
}

- (void) notificationCalendar {
    EKEventStore *eventStore = [EKEventStore new];
    EKEvent *events = [EKEvent eventWithEventStore:eventStore];
    
    events.title = self.detailMeeting[@"name"];
    events.startDate = [NSDate date];
    events.endDate = [NSDate date];
    events.availability = EKEventAvailabilityFree;
    
    EKEventEditViewController *editViewController = [[EKEventEditViewController alloc] init];
    editViewController.navigationBar.tintColor = [UIColor redColor];
    editViewController.editViewDelegate = self;
    editViewController.event = events;
    editViewController.eventStore = eventStore;
    [self presentViewController:editViewController animated:YES completion:nil];
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action{
    EKEvent *events = controller.event;
    EKEventStore * eventStore = controller.eventStore;

    [self dismissViewControllerAnimated:NO completion:^
     {
         switch (action)
         {
             {case EKEventEditViewActionCanceled:
                 [self buttonChangeColorWhenPressed:self.calendarNotification];
                 break;}
                 
//             {case EKEventEditViewActionDeleted:
//                 [self deleteEvent:thisEvent];
//                 NSError *error;
//                 EKEvent *eventRemove = [self.eventStore eventWithIdentifier:thisEvent.eventIdentifier];
//                 [self.eventStore removeEvent:eventRemove span:EKSpanThisEvent error:&error];
//                 //NSLog(@"Deleted action");
//                 break;}
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
