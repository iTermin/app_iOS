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
    
    self.viewModel =
    @[
        @{
            @"nib" : @"ProfilePhotoTableViewCell",
            @"height" : @(140),
        },
        @{
            @"nib" : @"HeaderTableViewCell",
            @"height" : @(80),
            @"data" : @{
                @"text" : @"Informacion General"
            }
        },
        @{
            @"nib" : @"HeaderTableViewCell",
            @"height" : @(80),
            @"data" : @{
                @"text" : @"Ayuda"
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

@end
