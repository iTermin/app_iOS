//
//  EditProfileUserViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/20/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "ModelTableViewController.h"
#import <UIKit/UIKit.h>

@interface EditProfileUserViewController : ModelTableViewController

@property (weak, nonatomic) IBOutlet UIImageView *photoProfileEdit;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;

@property(strong) NSDictionary *dataModel;

@property(nonatomic, strong) NSDictionary * currentLocation;

@end
