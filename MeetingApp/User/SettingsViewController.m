//
//  SettingsViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/18/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "SettingsViewController.h"
#import "EditProfileUserViewController.h"

@interface SettingsViewController ()
{
    BOOL changedInformation;
}

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayCountries = [ArrayOfCountries new];
    self.modelCountries = [self.arrayCountries getModelCountries];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    self.currentUser = [NSMutableDictionary dictionaryWithDictionary: @{
                         @"name" : @"Estefania Chavez Guardado",
                         @"email" : @"correo@gmail.com.mx",
                         @"code": @"MX",
                         @"photo" : @"",
                         }];
    
    [self updateViewModel];
    
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
                                @"height" : @(50),
                                @"data" : @{
                                        @"text" : @"Help"
                                        }
                                },
                            @{
                                @"nib" : @"OptionsSettingsTableViewCell",
                                @"height" : @(45),
                                @"data" : @{
                                        @"option" : @"Report Bug"
                                        }
                                },
                            @{
                                @"nib" : @"OptionsSettingsTableViewCell",
                                @"height" : @(45),
                                @"data" : @{
                                        @"option" : @"Privacy"
                                        }
                                },
                            @{
                                @"nib" : @"OptionsSettingsTableViewCell",
                                @"height" : @(45),
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

- (void)userInformation:(id<IUserInformation>)userDetail didChangedInformation:(NSDictionary *)user{
    changedInformation = YES;
    [self.currentUser removeAllObjects];
    self.currentUser =  [NSMutableDictionary dictionaryWithDictionary:user];
    
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
