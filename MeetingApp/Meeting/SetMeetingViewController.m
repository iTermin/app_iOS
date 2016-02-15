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

-(void)updateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.startMeeting.inputView;
    
    NSDate *date = picker.date;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMM d, hh:mm aa"];
    NSString *startFormat = [dateFormat stringFromDate:date];

    self.startMeeting.text = [NSString stringWithFormat:@"%@",startFormat];
    
    NSTimeInterval addDifference = 3600;
    NSDate * endDate = [date dateByAddingTimeInterval:addDifference];
    
    NSDateFormatter *endDateFormat = [[NSDateFormatter alloc] init];
    [endDateFormat setDateFormat:@"cccc, MMM d, hh:mm aa"];
    NSString *endFormat = [endDateFormat stringFromDate:endDate];
    
    self.endMeeting.text = [NSString stringWithFormat:@"%@",endFormat];
    
    
    /*NSCalendar *calendar = [NSCalendar currentCalendar];
     NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
     NSInteger hour = [components hour];
     NSInteger minute = [components minute];*/
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary *)sender {

}


@end
