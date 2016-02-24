//
//  ICountrySelector.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/24/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ICountrySelector.h"

@protocol ICountrySelectorDelegate <NSObject>

- (void) countrySelector: (id<ICountrySelector>) countrySelector
        didSelectCountry: (NSDictionary *) country;

@end