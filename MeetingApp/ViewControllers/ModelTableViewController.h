//
//  ModelTableViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/8/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModelTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(strong) UITableView *guestsTableView;
@property(strong) NSArray *viewModel;

- (void) updateViewModel;

@end
