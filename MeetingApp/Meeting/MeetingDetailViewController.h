//
//  MeetingDetailViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 12/28/15.
//  Copyright © 2015 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ModelTableViewController.h"
#import "Meeting.h"

@interface MeetingDetailViewController : ModelTableViewController

@property(nonatomic, strong) Meeting * currentMeeting;

@property(nonatomic, weak) IBOutlet UILabel * dateOfMeeting;
@property(nonatomic, weak) IBOutlet UILabel * timeOfMeeting;

@property(strong) NSArray *guests;
@property(strong) NSMutableDictionary *notications;

- (IBAction)buttonPressed:(id)sender;
- (IBAction)deleteMeetingPressed:(id)sender;

@end
