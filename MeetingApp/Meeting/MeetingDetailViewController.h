//
//  MeetingDetailViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 12/28/15.
//  Copyright © 2015 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKitUI/EventKitUI.h>

#import "ModelTableViewController.h"
#import "Meeting.h"
#import "IMeetingDelegate.h"
#import "IMeetingDatasource.h"
#import "IUserDelegate.h"
#import "IUserDatasource.h"

@interface MeetingDetailViewController : ModelTableViewController
<EKEventEditViewDelegate>

@property(nonatomic, strong) Meeting * currentMeeting;
@property (weak) id<IMeetingDelegate, IMeetingDatasource> meetingbusiness;
@property (weak) id<IUserDelegate, IUserDatasource> userbusiness;

@property(nonatomic, weak) IBOutlet UILabel * dateOfMeeting;
@property(nonatomic, weak) IBOutlet UILabel * timeOfMeeting;

@property(strong) NSDictionary *detailMeeting;
@property(strong) NSArray *guests;
@property(strong) NSMutableDictionary *notifications;

@property(strong) NSString *savedEventId;

- (IBAction)buttonPressed:(id)sender;

@end
