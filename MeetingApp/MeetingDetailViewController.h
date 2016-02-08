//
//  MeetingDetailViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 12/28/15.
//  Copyright © 2015 Estefania Chavez Guardado. All rights reserved.
//

#import "ModelTableViewController.h"
#import <UIKit/UIKit.h>

@interface MeetingDetailViewController : ModelTableViewController

@property(nonatomic, strong) NSDictionary * currentMeeting;

@property(nonatomic, weak) IBOutlet UILabel * dateOfMeeting;
@property(nonatomic, weak) IBOutlet UILabel * timeOfMeeting;

@property(strong) NSArray *guests;

- (IBAction)buttonPressed:(id)sender;
- (IBAction)deleteMeetingPressed:(id)sender;

@end
