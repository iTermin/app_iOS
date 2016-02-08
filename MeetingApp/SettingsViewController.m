//
//  SettingsViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/18/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "SettingsViewController.h"
#import "EditProfileUserViewController.h"

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    self.dataModel = @{
        @"name" : @"Estefania Chavez Guardado",
        @"email" : @"correo@gmail.com.mx",
        @"location": @"Mexico",
        @"code":@"MX"
    };
    
    [self updateViewModel];
    
}

- (void) updateViewModel {
    
    NSArray * viewModel = @[
                            @{
                                @"nib" : @"ProfilePhotoTableViewCell",
                                @"height" : @(120),
                                },
                            @{
                                @"nib" : @"GeneralInformationUserTableViewCell",
                                @"height" : @(100),
                                @"data" : [self.dataModel copy]
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
                                },
                            @{
                                @"nib" : @"HeaderTableViewCell",
                                @"height" : @(50),
                                @"data" : @{
                                        @"text" : @"Notifications"
                                        }
                                }
                            ];
    
    self.viewModel = [NSMutableArray arrayWithArray: viewModel];
    
    [super updateViewModel];
}


- (void) configureCell: (UITableViewCell *) cell withModel: (NSDictionary *) cellModel {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary *)sender {
    if ([segue.identifier isEqualToString:@"editProfile"]){        
        EditProfileUserViewController * informationViewController = (EditProfileUserViewController *)segue.destinationViewController;
        [informationViewController setDataModel: self.dataModel];
    }
}

- (void) performSegue:(NSIndexPath *)indexPath{
}

@end
