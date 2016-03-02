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

@interface ListCountriesViewController : ModelTableViewController

@property (strong) NSArray * modelCountries;
@property (nonatomic, strong) ArrayOfCountries *arrayCountries;

@property(nonatomic, strong) NSDictionary * currentLocation;

@end
