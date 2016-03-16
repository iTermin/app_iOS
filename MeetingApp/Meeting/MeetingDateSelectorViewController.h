//
//  MeetingDateSelectorViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/17/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArrayOfCountries.h"
#import "IMeetingAllDayDelegate.h"

@interface MeetingDateSelectorViewController : UITableViewController <IMeetingAllDayDelegate>

@property(nonatomic, strong) NSDictionary * detailMeeting;
@property(strong) NSArray *viewModel;

@property (nonatomic, strong) ArrayOfCountries *arrayCountries;
@property (strong) NSArray * modelCountries;
@property (strong) NSDictionary * userInformation;

@property (strong) NSDate * dateCurrent;
@property (strong) NSMutableArray * hoursArray;

- (IBAction)sharePressed:(id)sender;
- (IBAction)trashPressed:(id)sender;
- (IBAction)doneMeetingPressed:(id)sender;

@end
