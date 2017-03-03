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
    
    CALayer *emailBorder = [CALayer layer];
    emailBorder.frame = CGRectMake(0.0f,
                                   self.emailUser.frame.size.height - 1,
                                   self.emailUser.frame.size.width,
                                   1.0f);
    emailBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.emailUser.layer addSublayer:emailBorder];
    self.emailUser.delegate = self;
}

- (void) getUserFromDB{
    [self.userbusiness updateUserWithCallback:^(id<IUserDatasource> handler) {
        self.userInformation = [NSMutableDictionary dictionaryWithDictionary:[handler getUser]];
        if ([self isValidateEmail]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else{
            self.emailUser.text = @"";
            [self alertNotValidateUser];
            NSLog(@"Datos incorrectos");
        }
    }];
}

- (void) alertNotValidateUser{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Invalid Email"
                                message:@"Doesn´t exist user with this email."
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action){
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL) isValidateEmail{
    return [self.userInformation[@"email"] isEqualToString:self.emailUser.text] ? YES : NO;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailUser)
        [self inputEmail];
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void) inputEmail {
    NSString *emailUser = self.emailUser.text;
    if (![self.emailUser.text isEqualToString:self.userInformation[@"email"]]){
        BOOL emailIsValid = [self validateEmail:self.emailUser.text];
        if (emailIsValid){
            [self.userInformation removeObjectForKey:@"email"];
            [self.userInformation setObject:emailUser forKey:@"email"];
        }
        else{
            [self wrongEmail];
        }
    }
}

- (BOOL) validateEmail:(NSString*) emailAddress{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self.emailUser.text];
    //ref:http://stackoverflow.com/a/22344769/5757715
}

- (void) wrongEmail{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Wrong Email!"
                                message:@"The email is incorrect. Please enter the correct email (email@gmail.com)."
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action){
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)userRegistered:(id)sender {
    [self getUserFromDB];
}

- (IBAction)registerNewUser:(id)sender {
    self.registerNewUser = [self.userbusiness getTemporalUser];

    [self.userbusiness updateDetailUser:self.registerNewUser];
}
@end
