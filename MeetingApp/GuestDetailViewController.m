//
//  GuestDetailViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 12/31/15.
//  Copyright © 2015 Estefania Chavez Guardado. All rights reserved.
//

#import "GuestDetailViewController.h"

@implementation GuestDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.locationGuestTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self.nameOfGuest setText: self.currentGuest[@"name"]];
    [self.emailOfGuest setText: self.currentGuest[@"email"]];

}

@end
