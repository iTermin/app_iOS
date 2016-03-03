//
//  GuestListCountriesTableViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/5/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ModelTableViewController.h"

#import "ICountrySelector.h"
#import "ICountrySelectorDelegate.h"
#import "ArrayOfCountries.h"


@interface GuestListCountriesTableViewController : ModelTableViewController <ICountrySelector>

@property(nonatomic, strong) NSDictionary * currentGuest;

@property (strong) NSArray * modelCountries;
@property (nonatomic, strong) ArrayOfCountries *arrayCountries;

@property(weak) id<ICountrySelectorDelegate> countrySelectorDelegate;

@end
