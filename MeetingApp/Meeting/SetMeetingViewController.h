//
//  SetMeetingViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/3/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetMeetingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *startMeeting;

@property (weak, nonatomic) IBOutlet UITextField *endMeeting;

@property(nonatomic, strong) NSMutableDictionary * guestMeeting;


@end
