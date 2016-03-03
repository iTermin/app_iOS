//
//  EditGuestDetailViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/31/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ModelTableViewController.h"
#import "ICountrySelectorDelegate.h"
#import "ArrayOfCountries.h"

#import "IGuestInformation.h"
#import "IGuestInformationDelegate.h"

@interface EditGuestDetailViewController : ModelTableViewController <UITextFieldDelegate, ICountrySelectorDelegate, IGuestInformation>

@property (strong, nonatomic) IBOutlet UIImageView *guestPhoto;
@property (strong, nonatomic) IBOutlet UITextField *nameGuest;
@property (strong, nonatomic) IBOutlet UITextField *emailGuest;

@property(nonatomic, strong) NSMutableDictionary * currentGuest;
@property(nonatomic, strong) NSMutableDictionary *guestInformation;

@property (strong) NSArray * modelCountries;
@property (nonatomic, strong) ArrayOfCountries *arrayCountries;


@property(weak) id<IGuestInformationDelegate> guestInformationDelegate;

@end
