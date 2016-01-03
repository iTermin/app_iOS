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
}

- (void)didReceiveMemoryWarning {

}

- (void) viewWillAppear:(BOOL)animated {

}

-(void)updateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.startMeeting.inputView;
    self.startMeeting.text = [NSString stringWithFormat:@"%@",picker.date];
}


@end
