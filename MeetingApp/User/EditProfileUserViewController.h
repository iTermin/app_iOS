//
//  EditProfileUserViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/20/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ICountrySelectorDelegate.h"
#import "ModelTableViewController.h"

#import "IUserInformation.h"
#import "IUserInformationDelegate.h"
#import "ArrayOfCountries.h"

@interface EditProfileUserViewController : ModelTableViewController
<ICountrySelectorDelegate, IUserInformation,
UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoProfileEdit;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;

@property(nonatomic, strong) NSDictionary * currentHost;
@property(nonatomic, strong) NSMutableDictionary * hostInformation;

@property(nonatomic, strong) NSDictionary * currentLocation;

@property(weak) id<IUserInformationDelegate> userInformationDelegate;


@end
