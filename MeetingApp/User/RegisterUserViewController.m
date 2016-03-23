//
//  RegisterUserViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 3/22/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "RegisterUserViewController.h"
#import "SettingsViewController.h"
#import "MainAssembly.h"

@interface RegisterUserViewController ()

@end

@implementation RegisterUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.userbusiness = [[MainAssembly defaultAssembly] userBusinessController];
    
    self.registerNewUser = [self.userbusiness getTemporalUser];

}

- (IBAction)userRegistered:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerNewUser:(id)sender {
    [self.userbusiness updateDetail:self.registerNewUser];
}
@end
