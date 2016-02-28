//
//  MeetingDateSelectorViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/17/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "UXDateCellsManager.h"
#import "MeetingDateSelectorViewController.h"

@interface MeetingDateSelectorViewController ()

@property (strong, nonatomic) UXDateCellsManager *dateCellsManager;
@property(nonatomic, strong) NSMutableSet * registeredNibs;

@end

@implementation MeetingDateSelectorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the initial values for the date cells manager
    NSDate *startDate = [NSDate date]; //now
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 7]; //one week from now
    NSIndexPath *allDayCellIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *startDateCellIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    NSIndexPath *endDateCellIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    
    // Set up the date cells manager
    self.dateCellsManager = [[UXDateCellsManager alloc] initWithTableView:self.tableView
                                                                startDate:startDate
                                                                  endDate:endDate
                                                                 isAllDay:NO
                                                   indexPathForAllDayCell:allDayCellIndexPath
                                                indexPathForStartDateCell:startDateCellIndexPath
                                                  indexPathForEndDateCell:endDateCellIndexPath];
    
    self.registeredNibs = [NSMutableSet set];

    [self updateViewModel];

    __weak UITableView * tableView = self.tableView;
    [self.viewModel enumerateObjectsUsingBlock:^(NSDictionary * cellViewModel, NSUInteger idx, BOOL * stop) {
        
        NSString * nibFile = cellViewModel[@"nib"];
        
        if(![self.registeredNibs containsObject: nibFile]) {
            [self.registeredNibs addObject: nibFile];
            
            UINib * nib = [UINib nibWithNibName:nibFile bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:nibFile];
        }
    }];
    

}

- (void)viewWillAppear:(BOOL)animated{
    
    //[self updateViewModel];
}

-(void) updateViewModel{
    NSMutableArray * viewModel = [NSMutableArray array];
    [self.guestMeeting enumerateObjectsUsingBlock:^(NSDictionary * guest, NSUInteger idx, BOOL * stop) {
        
        NSMutableDictionary * cellModel = [NSMutableDictionary dictionaryWithDictionary:guest];
        
        [viewModel addObject:@{
                               @"nib" : @"GuestDateViewCell",
                               @"height" : @(60),
                               @"data":cellModel }];
    }];
    
    self.viewModel = viewModel;
    
}

#pragma mark - Table view delegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Date Cells
    if ([self.dateCellsManager isManagedDateCell:indexPath]) {
        return [self.dateCellsManager tableView:tableView willSelectRowAtIndexPath:indexPath];
    }
    
    // Other cells
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Date Cells
    if ([self.dateCellsManager isManagedDateCell:indexPath]) {
        return [self.dateCellsManager tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    
    // Other cells
    // ...
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section, allowing for the potentially visible date picker
    if (section == 0) {
        return 3 + [self.dateCellsManager numberOfVisibleDatePickers];
    }
    if (section == 1) {
        return [self.viewModel count];
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // DatePickerCell
    if ([indexPath isEqual:[self.dateCellsManager indexPathOfVisibleDatePicker]]) {
        return [self.dateCellsManager heightOfDatePickerCell];
    }
    
    if (indexPath.section == 1){
        NSDictionary * cellViewModel = self.viewModel[indexPath.row];
        return [cellViewModel[@"height"] floatValue];
    }
    
    // All other cells
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Date Cells
    if ([self.dateCellsManager isManagedDateCell:indexPath]) {
        return [self.dateCellsManager tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    if (indexPath.section == 1){
        NSDictionary * cellViewModel = self.viewModel[indexPath.row];
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: cellViewModel[@"nib"]];
        
        if([cell respondsToSelector:@selector(setData:)]) {
            [cell performSelector:@selector(setData:) withObject:cellViewModel[@"data"]];
        }
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier" forIndexPath:indexPath];
    
    return cell;
}

@end
