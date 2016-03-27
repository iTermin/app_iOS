//
//  ViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 12/26/15.
//  Copyright © 2015 Estefania Chavez Guardado. All rights reserved.
//

#import "MeetingTableViewController.h"

#import <SWTableViewCell.h>

#import "MeetingDetailViewController.h"
#import "BeginMeetingViewController.h"
#import "MainAssembly.h"
#import "MBProgressHUD.h"


@interface MeetingTableViewController ()

@end

@implementation MeetingTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    hud.color = [UIColor lightGrayColor];
    
    self.meetingbusiness = [[MainAssembly defaultAssembly] meetingBusinessController];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.meetingbusiness updateMeetingsWithCallback:^(id<IMeetingDatasource> handler) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.meetings = [handler getAllMeetings];
        [self updateViewModel];
        [self.tableView reloadData];
    }];
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
                               @"height" : @(70),
                               @"segue" : @"meetingDetail",
                               @"data":cellModel }];
    }];
    
    self.viewModel = viewModel;
    
    [super updateViewModel];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * cellViewModel = self.viewModel[indexPath.row];
    NSString * cellIdentifier = cellViewModel[@"nib"];
    
    SWTableViewCell * cell = (SWTableViewCell*)[tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    
    if([cell respondsToSelector:@selector(setData:)]) {
        [cell performSelector:@selector(setData:) withObject:cellViewModel[@"data"]];
    }
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    return cell;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            //[self.listOfGuests removeObjectAtIndex:cellIndexPath.row];
            [self removeIndexPathFromViewModel: cellIndexPath];
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            break;
        }
        default:
            break;
    }
}

- (void) removeIndexPathFromViewModel: (NSIndexPath *) indexPath{
    NSMutableArray *temporalViewModel = [NSMutableArray arrayWithArray:self.viewModel];
    [temporalViewModel removeObjectAtIndex:indexPath.row];
    self.viewModel = temporalViewModel;
}

- (void) performSegue: (NSIndexPath *)indexPath{
    NSDictionary * cellModel = self.viewModel[indexPath.row];
    NSString * segueToPerform = cellModel[@"segue"];
    if([segueToPerform isEqualToString:@"meetingDetail"]) {
        NSDictionary * selectedMeeting = self.meetings[indexPath.row];
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
        MutableMeeting * newMeeting = [[[MainAssembly defaultAssembly] meetingBusinessController] getTemporalMeeting];
        UINavigationController *navigationBeginMeetin = (UINavigationController *)segue.destinationViewController;
        BeginMeetingViewController * beginMeetingViewController = (BeginMeetingViewController *)navigationBeginMeetin.topViewController;
        [beginMeetingViewController setCurrentMeeting: newMeeting];
    }
}

- (IBAction)reloadData:(UIRefreshControl *)sender {
    [self.meetingbusiness updateMeetingsWithCallback:^(id<IMeetingDatasource> handler) {
        
        // TODO: Extract to new method
        self.meetings = [handler getAllMeetings];;
        [self updateViewModel];
        [self.tableView reloadData];
        
        [sender endRefreshing];
    }];
}

@end
