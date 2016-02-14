//
//  EditProfileUserViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/20/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <RSKImageCropper.h>
#import "ModelTableViewController.h"
#import <UIKit/UIKit.h>

@interface EditProfileUserViewController : ModelTableViewController <RSKImageCropViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoProfileEdit;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (strong, nonatomic) IBOutlet UIButton *photoEditButton;

@property(strong) NSDictionary *dataModel;

@property(nonatomic, strong) NSDictionary * currentLocation;
- (IBAction)editPhotoUser:(id)sender;

@end
