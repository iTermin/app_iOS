//
//  SettingsViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/18/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "SettingsViewController.h"
#import <AdSupport/ASIdentifierManager.h>

#import "MainAssembly.h"
#import "MBProgressHUD.h"

#import "EditProfileUserViewController.h"
#import "RegisterUserViewController.h"

@interface SettingsViewController ()
{
    BOOL changedInformation;
}

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    hud.color = [UIColor lightGrayColor];
    
    self.arrayCountries = [ArrayOfCountries new];
    self.modelCountries = [self.arrayCountries getModelCountries];
    
    self.userbusiness = [[MainAssembly defaultAssembly] userBusinessController];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.userbusiness updateUser:[self getDeviceId] WithCallback:^(id<IUserDatasource> handler) {
        self.currentUser = [NSMutableDictionary dictionaryWithDictionary:[handler getUser]];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (![self.currentUser count]) [self presentRegisterUserViewController];
        else{
            [self updateViewModel];
            [self.tableView reloadData];
        }
    }];
}

- (void) presentRegisterUserViewController{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegisterUserViewController* myVC = [sb instantiateViewControllerWithIdentifier:@"RegisterUser"];
    [self presentViewController:myVC animated:YES completion:nil];
}

- (NSString*) getDeviceId{
    //UIDevice *device = [UIDevice currentDevice];
    //return [[device identifierForVendor]UUIDString];
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

- (void) updateViewModel {
    
    NSString *countryName = [self getNameCountry:self.currentUser];
    [self.currentUser setObject:countryName forKey:@"country"];
    
    NSArray * viewModel = @[
                            @{
                                @"nib" : @"GeneralInformationUserTableViewCell",
                                @"height" : @(255),
                                @"data" : [self.currentUser copy]
                                },
                            @{
                                @"nib" : @"HeaderTableViewCell",
                                @"height" : @(60),
                                @"data" : @{
                                        @"text" : @"Help"
                                        }
                                },
                            @{
                                @"nib" : @"OptionsSettingsTableViewCell",
                                @"height" : @(50),
                                @"data" : @{
                                        @"option" : @"Report Bug"
                                        }
                                },
                            @{
                                @"nib" : @"OptionsSettingsTableViewCell",
                                @"height" : @(50),
                                @"data" : @{
                                        @"option" : @"Privacy"
                                        }
                                },
                            @{
                                @"nib" : @"OptionsSettingsTableViewCell",
                                @"height" : @(50),
                                @"data" : @{
                                        @"option" : @"Terms of Service"
                                        }
                                }
                            ];
    
    self.viewModel = [NSMutableArray arrayWithArray: viewModel];
    
    if (changedInformation){
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        changedInformation = NO;
    }
    [super updateViewModel];
}

- (NSString*) getNameCountry: (NSDictionary *)dataInformation{
    NSString *codeCountry = dataInformation[@"code"];
    NSString *nameCountry = [NSString new];
    
    NSArray * ListCountriesInformation = self.modelCountries;
    NSDictionary * countryInformaton = [NSDictionary dictionary];
    
    for (countryInformaton in ListCountriesInformation) {
        NSString * code = countryInformaton[@"code"];
        if ([code isEqualToString: codeCountry]) {
            return nameCountry = countryInformaton[@"name"];
        }
    }
    return nameCountry;
}

- (void)userInformation:(id<IUserDatasource>)userDetail didChangedInformation:(NSDictionary *)user{
    changedInformation = YES;
    [self.currentUser removeAllObjects];
    self.currentUser =  [NSMutableDictionary dictionaryWithDictionary:user];
    [self.userbusiness updateDetailUser:self.currentUser];
    
    [self updateViewModel];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary *)sender {
    if ([segue.identifier isEqualToString:@"editProfile"]){        
        EditProfileUserViewController * informationViewController = (EditProfileUserViewController *)segue.destinationViewController;
        [informationViewController setCurrentHost: self.currentUser];
        [informationViewController setUserInformationDelegate:self];
    }
}

- (void) performSegue:(NSIndexPath *)indexPath{
}

@end
