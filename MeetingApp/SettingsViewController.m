//
//  SettingsViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/18/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    
    self.viewModel =
    @[
        @{
            @"nib" : @"ProfilePhotoTableViewCell",
            @"height" : @(120),
        },
        @{
            @"nib" : @"GeneralInformationUserTableViewCell",
            @"height" : @(100),
            @"data" : @{
                    @"name" : @"Estefania Chavez Guardado",
                    @"email" : @"correo@gmail.com.mx",
                    @"location": @"Mexico"
                    }
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
    
    __weak UITableView * tableView = self.tableView;
    NSMutableSet * registeredNibs = [NSMutableSet set];
    
    [self.viewModel enumerateObjectsUsingBlock:^(NSDictionary * cellViewModel, NSUInteger idx, BOOL * stop) {
        
        NSString * nibFile = cellViewModel[@"nib"];
        
        if(![registeredNibs containsObject: nibFile]) {
            [registeredNibs addObject: nibFile];
            
            UINib * nib = [UINib nibWithNibName:nibFile bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:nibFile];
        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary * cellViewModel = self.viewModel[indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: cellViewModel[@"nib"]];
    
    if([cell respondsToSelector:@selector(setData:)]) {
        [cell performSelector:@selector(setData:) withObject:cellViewModel[@"data"]];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * cellViewModel = self.viewModel[indexPath.row];
    return [cellViewModel[@"height"] floatValue];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary *)sender {
    if ([segue.identifier isEqualToString:@"editProfile"]){
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        //SettingsViewController * informationViewController = (SettingsViewController *)segue.destinationViewController;
        //[informationViewController setViewModel:self.viewModel];
    }
}

@end
