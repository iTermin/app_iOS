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
    // Do any additional setup after loading the view, typically from a nib.

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
    self.tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.meetings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"IDENTIFIER"];
    cell.textLabel.font = [UIFont fontWithName:@"BodoniSvtyTwoITCTT-Bold" size:15];
    cell.detailTextLabel.font = [UIFont fontWithName:@"BodoniSvtyTwoITCTT-Book" size:11];
    [[cell textLabel] setText: self.meetings[indexPath.row][@"name"]];
    [[cell detailTextLabel] setText: self.meetings[indexPath.row][@"date"] ];
    [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
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
    }
    if ([segue.identifier isEqualToString:@"newMeeting"]){
        
    }
}

@end
