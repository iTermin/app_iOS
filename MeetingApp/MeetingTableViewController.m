//
//  ViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 12/26/15.
//  Copyright © 2015 Estefania Chavez Guardado. All rights reserved.
//

#import "MeetingTableViewController.h"
#import "MeetingDetailViewController.h"


@interface MeetingTableViewController ()

@end

@implementation MeetingTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.meetings = @[
            @{
                    @"active" : @(true),
                    @"date" : @"2015-12-11",
                    @"meetingId" : @"m1",
                    @"name" : @"Meeting 1"
            },
            @{
                    @"active" : @(true),
                    @"date" : @"2015-11-15",
                    @"meetingId" : @"m2",
                    @"name" : @"Meeting 2"
            }
    ];
    
    [self getCountry];
    
    [self updateViewModel];
    
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

- (void) updateViewModel {
    NSMutableArray * viewModel = [NSMutableArray array];
    [self.meetings enumerateObjectsUsingBlock:^(NSDictionary * guests, NSUInteger idx, BOOL * stop) {
        
        NSMutableDictionary * cellModel = [NSMutableDictionary dictionaryWithDictionary:guests];
        
        [viewModel addObject:@{
                               @"nib" : @"MeetingTableViewCell",
                               @"height" : @(60),
                               @"data":cellModel }];
    }];
    
    self.viewModel = viewModel;
}

-(void) getCountry{
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    
    // TODO: Add the country to the user data model
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * selectedMeeting = self.meetings[indexPath.row];
    [self performSegueWithIdentifier:@"meetingDetail" sender: selectedMeeting];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary *)sender {
    if ([segue.identifier isEqualToString:@"meetingDetail"]){
        MeetingDetailViewController * detailViewController = (MeetingDetailViewController *)segue.destinationViewController;
        [detailViewController setTitle:sender[@"name"]];
        [detailViewController setCurrentMeeting: sender];
    } else if ([segue.identifier isEqualToString:@"newMeeting"]){
        // TODO: Send the data model from the user
    }
}

@end
