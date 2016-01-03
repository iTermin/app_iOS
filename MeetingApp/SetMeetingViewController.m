//
//  SetMeetingViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/3/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "SetMeetingViewController.h"

@interface SetMeetingViewController()

@end

@implementation SetMeetingViewController

- (void)viewDidLoad{
    UIDatePicker * datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.startMeeting setInputView:datePicker];
    [self.endMeeting setInputView:datePicker];
}

- (void)didReceiveMemoryWarning {

}

- (void) viewWillAppear:(BOOL)animated {

}

-(void)updateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.startMeeting.inputView;
    
    
    NSDate *date = picker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMM d, hh:mm aa"];
    NSString *format = [dateFormat stringFromDate:date];
    
    self.startMeeting.text = [NSString stringWithFormat:@"%@",format];
    self.endMeeting.text = [NSString stringWithFormat:@"%@",format];
    
}


@end
