//
//  MeetingBeginViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 12/28/15.
//  Copyright © 2015 Estefania Chavez Guardado. All rights reserved.
//

#import <Contacts/Contacts.h>

#import "BeginMeetingViewController.h"
#import "SetMeetingViewController.h"


@interface BeginMeetingViewController ()

@end

@implementation BeginMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CALayer *nameBorder = [CALayer layer];
    nameBorder.frame = CGRectMake(0.0f, self.nameMeeting.frame.size.height - 1, self.nameMeeting.frame.size.width, 1.0f);
    nameBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.nameMeeting.layer addSublayer:nameBorder];
    
    CALayer *guestBorder = [CALayer layer];
    guestBorder.frame = CGRectMake(0.0f, self.nameGuest.frame.size.height - 1, self.nameGuest.frame.size.width, 1.0f);
    guestBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.nameGuest.layer addSublayer:guestBorder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary *)sender {
    //SetMeetingViewController * setMeetingViewController = (SetMeetingViewController *)segue.destinationViewController;

    if ([segue.identifier isEqualToString:@"inviteGuests"]){
        
    }
}

- (IBAction)inviteGuests:(id)sender {
    if ([CNContactStore class]) {
        [self performSegueWithIdentifier:@"inviteGuests" sender: @"hola"];
    }
}
@end