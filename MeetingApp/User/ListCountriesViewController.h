//
//  ListCountriesViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/24/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ModelTableViewController.h"
#import "ArrayOfCountries.h"
#import "ICountrySelector.h"
#import "ICountrySelectorDelegate.h"


@interface ListCountriesViewController : ModelTableViewController <ICountrySelector>

@property (strong) NSArray * modelCountries;
@property (nonatomic, strong) ArrayOfCountries *arrayCountries;

@property(nonatomic, strong) NSDictionary * currentLocation;

@property(weak) id<ICountrySelectorDelegate> countrySelectorDelegate;

@end
