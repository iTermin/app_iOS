//
//  MeetingDateSelectorViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/17/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArrayOfCountries.h"

@interface MeetingDateSelectorViewController : UITableViewController

@property(nonatomic, strong) NSMutableArray * guestMeeting;
@property(strong) NSArray *viewModel;

@property (nonatomic, strong) ArrayOfCountries *arrayCountries;
@property (strong) NSArray * modelCountries;

@property (strong) NSDate * dateCurrent;
@property (strong) NSMutableArray * hoursArray;

@end
