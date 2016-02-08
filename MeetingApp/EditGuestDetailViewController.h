//
//  EditGuestDetailViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/31/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "ModelTableViewController.h"
#import <UIKit/UIKit.h>

@interface EditGuestDetailViewController : ModelTableViewController

@property (strong, nonatomic) IBOutlet UIImageView *guestPhoto;
@property (strong, nonatomic) IBOutlet UITextField *nameGuest;
@property (strong, nonatomic) IBOutlet UITextField *emailGuest;

@property(nonatomic, strong) NSMutableDictionary * currentGuest;

@property(strong) NSDictionary *dataModel;

@end
