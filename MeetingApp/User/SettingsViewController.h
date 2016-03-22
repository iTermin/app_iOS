//
//  SettingsViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/18/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IUserDelegate.h"
#import "ModelTableViewController.h"
#import "ArrayOfCountries.h"

@interface SettingsViewController : ModelTableViewController <IUserDelegate>

@property(strong) NSMutableDictionary *currentUser;

@property (strong) NSArray * modelCountries;
@property (nonatomic, strong) ArrayOfCountries *arrayCountries;

@end
