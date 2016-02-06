//
//  MeetingDetailViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 12/28/15.
//  Copyright © 2015 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSDictionary * currentMeeting;

@property(nonatomic, weak) IBOutlet UILabel * dateOfMeeting;
@property(nonatomic, weak) IBOutlet UILabel * timeOfMeeting;
@property (strong, nonatomic) IBOutlet UITableView *guestTableView;

@property(strong) NSArray *guests;
@property(strong, nonatomic) NSArray *viewModel;

- (IBAction)buttonPressed:(id)sender;
- (IBAction)deleteMeetingPressed:(id)sender;

@end
