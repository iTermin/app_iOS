//
//  ListCountriesViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/24/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "ModelTableViewController.h"
#import <UIKit/UIKit.h>

@interface ListCountriesViewController : ModelTableViewController

@property(strong) NSDictionary *dataModel;

@property(nonatomic, strong) NSDictionary * currentLocation;

@end
