//
//  RegisterUserViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 3/22/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "User.h"
#import "IUserDatasource.h"
#import "IUserDelegate.h"

@interface RegisterUserViewController : UIViewController <UITextFieldDelegate>

@property(nonatomic, strong) MutableUser * registerNewUser;
@property(nonatomic, strong) NSMutableDictionary * userInformation;

@property (weak) id<IUserDatasource, IUserDelegate> userbusiness;

@property (strong, nonatomic) IBOutlet UITextField *emailUser;

- (IBAction)userRegistered:(id)sender;
- (IBAction)registerNewUser:(id)sender;

@end
