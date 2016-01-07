//
//  SetMeetingTableViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/7/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "SetMeetingTableViewController.h"

@implementation SetMeetingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"Information", @"Information");
            break;
        case 1:
            sectionName = NSLocalizedString(@"Guest", @"Guest");
            break;
        default:
            break;
    }
    return sectionName;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IDENTIFIER"];
    
    return cell;
}



@end
