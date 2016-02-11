//
//  GuestListCountriesTableViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/5/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "ModelTableViewController.h"
#import <UIKit/UIKit.h>

@interface GuestListCountriesTableViewController : ModelTableViewController

@property(nonatomic, strong) NSDictionary * currentGuest;

@property(strong) NSDictionary *dataModel;

@end
