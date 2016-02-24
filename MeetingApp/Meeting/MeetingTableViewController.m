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
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;

    [self getCountry];
    
    [self updateViewModel];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"bussiness"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"This is your Board Meetings";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"When you created Meetings, their will show up here. Start up!";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void) updateViewModel {
    NSMutableArray * viewModel = [NSMutableArray array];
    [self.meetings enumerateObjectsUsingBlock:^(NSDictionary * guests, NSUInteger idx, BOOL * stop) {
        
        NSMutableDictionary * cellModel = [NSMutableDictionary dictionaryWithDictionary:guests];
        
        [viewModel addObject:@{
                               @"nib" : @"MeetingTableViewCell",
                               @"height" : @(60),
                               @"segue" : @"meetingDetail",
                               @"data":cellModel }];
    }];
    
    self.viewModel = viewModel;
    
    [super updateViewModel];
}

-(void) getCountry{
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    
    // TODO: Add the country to the user data model
}

- (void) performSegue: (NSIndexPath *)indexPath{
    NSDictionary * selectedMeeting = self.meetings[indexPath.row];
    NSDictionary * cellModel = self.viewModel[indexPath.row];
    NSString * segueToPerform = cellModel[@"segue"];
    if(segueToPerform) {
        [self performSegueWithIdentifier: segueToPerform
                                  sender: selectedMeeting];

    }
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