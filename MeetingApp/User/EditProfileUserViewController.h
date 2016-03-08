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

@interface EditProfileUserViewController : ModelTableViewController
<ICountrySelectorDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoProfileEdit;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;

@property(strong) NSDictionary *dataModel;

@property(nonatomic, strong) NSDictionary * currentLocation;

@end
