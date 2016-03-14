//
//  MeetingDateSelectorViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/17/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "UXDateCellsManager.h"
#import "MeetingDateSelectorViewController.h"
#import "ArrayOfCountries.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@interface MeetingDateSelectorViewController ()

@property (strong, nonatomic) UXDateCellsManager *dateCellsManager;
@property(nonatomic, strong) NSMutableSet * registeredNibs;

@end

@implementation MeetingDateSelectorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // Set up the initial values for the date cells manager
    NSDate *startDate = [NSDate date]; //now
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:7200]; //one week from now
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
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.arrayCountries = [ArrayOfCountries new];
    self.modelCountries = [self.arrayCountries getModelCountries];
    self.dateCurrent = [NSDate new];
    self.dateCurrent = startDate;
    
    self.hoursArray = [NSMutableArray array];
    
    // TODO :[self inputAlgoritm:startDate];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //[self updateViewModel];
}

-(void) updateViewModel{
    NSMutableArray * viewModel = [NSMutableArray array];
    NSArray * guestsOfMeeting = self.detailMeeting[@"guests"];
    [guestsOfMeeting enumerateObjectsUsingBlock:^(NSDictionary * guest, NSUInteger idx, BOOL * stop) {
        
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
        self.dateCurrent = self.dateCellsManager.startDate;
        [self inputAlgoritm:self.dateCurrent];
        return [self.dateCellsManager tableView:tableView willSelectRowAtIndexPath:indexPath];
    }
    
    // Other cells
    return indexPath;
}

-(void) inputAlgoritm: (NSDate *) startDate {
    
    NSDictionary * userDate = [self getHourOfDate:startDate];
    [self.hoursArray addObject:userDate[@"hour"]];
    
    [self.viewModel enumerateObjectsUsingBlock:^(NSDictionary * guest, NSUInteger idx, BOOL * stop) {
        NSDictionary *dataGuest = guest[@"data"];
        [self gethourGuest: dataGuest[@"codeCountry"] respectUser:userDate];
    }];
    
    NSArray * prepareHours = [NSArray arrayWithArray:self.hoursArray];
    [self.hoursArray removeAllObjects];
    [self prepareHoursForAlgorithm: prepareHours];
}

- (void) prepareHoursForAlgorithm : (NSArray *) hours{
    NSMutableSet *existingHours = [NSMutableSet set];
    [hours enumerateObjectsUsingBlock:^(id hour, NSUInteger idx, BOOL * stop){
        if (![existingHours containsObject:hour]) {
            [existingHours addObject:hour];
            [self.hoursArray addObject:hour];
        }
    }];
}

- (void) gethourGuest: (NSString *) guestCountry respectUser: (NSDictionary *) userDate{
    NSArray * UTCGuest  = [self getUTCGuest: guestCountry];
    NSArray * UTCUser = [self getUTCGuest: userDate[@"countryCode"]];
    if(![UTCUser isEqualToArray:UTCGuest]){

        [UTCUser enumerateObjectsUsingBlock:^(id hour, NSUInteger idx, BOOL * stop) {
            [self addDiferencial:[hour doubleValue] ToGuest:UTCGuest withCurrentHours:[userDate[@"hour"] doubleValue]];
        }];
        
    } else {
        [self.hoursArray addObject:userDate[@"hour"]];
    }
}

-(NSArray *) getUTCGuest: (NSString *) codeCountry{
    __block NSArray *UTCGuest = [NSArray array];
    
    [self.modelCountries enumerateObjectsUsingBlock:^(NSDictionary * country, NSUInteger idx, BOOL * stop) {
        if([country[@"code"] isEqualToString:codeCountry])
            UTCGuest = [NSArray arrayWithArray:country[@"UTC"]];
    }];
    return UTCGuest;
}

- (void) addDiferencial: (double) UTC_hourUser ToGuest: (NSArray *) UTC_country withCurrentHours: (double) currentHours{
    [UTC_country enumerateObjectsUsingBlock:^(id hour, NSUInteger idx, BOOL * stop) {
        
        double temporalHour = UTC_hourUser < 0 ?
        (UTC_hourUser + [hour doubleValue]) + currentHours :
        (UTC_hourUser - [hour doubleValue]) + currentHours;
        
        temporalHour = temporalHour <= 0 ? temporalHour + 24.0 : temporalHour;
        temporalHour = temporalHour > 24 ? temporalHour - 24 : temporalHour;
        
        NSNumber *hourGuest = [NSNumber numberWithDouble:(temporalHour)];
        [self.hoursArray addObject: hourGuest];
    }];
}

- (NSDictionary *) getHourOfDate: (NSDate *) startDate{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"HH"];
    int hour = [[dateFormatter stringFromDate:startDate] intValue];
    [dateFormatter setDateFormat:@"mm"];
    int minutes = [[dateFormatter stringFromDate:startDate] intValue];
    
    return @{ @"hour" : @(hour), @"minutes" : @(minutes), @"countryCode" : [self getCountryUser]};
}

-(NSString *) getCountryUser {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *mobileNetworkInfo = [networkInfo subscriberCellularProvider];
    return [[mobileNetworkInfo isoCountryCode] uppercaseString];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CGRect labelFrame = CGRectMake(40, 80, 280, 150);
    UILabel * sectionHeader = [[UILabel alloc]initWithFrame:labelFrame];
    sectionHeader.backgroundColor = [UIColor clearColor];
    sectionHeader.textAlignment = NSTextAlignmentCenter;
    [sectionHeader sizeToFit];
    [sectionHeader setNumberOfLines: 0];
    sectionHeader.font = [UIFont fontWithName:@"BodoniSvtyTwoITCTT-Bold" size:18];
    sectionHeader.textColor = [UIColor colorWithRed:.290 green:.564 blue:.886 alpha:1];

    switch (section) {
        case 0: sectionHeader.text = @"Date Proposal"; break;
        case 1: sectionHeader.text = @"Guest State"; break;
        default: break;
    }
    
    return sectionHeader;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

- (IBAction)sharePressed:(id)sender {
        
    NSMutableString *texttoshare = [NSMutableString stringWithFormat:@"You are invited to "];
    [texttoshare appendString:self.detailMeeting[@"name"]];
    //TODO : extract date and send url
    
    NSArray *activityItems = @[texttoshare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    [self presentViewController:activityVC animated:TRUE completion:nil];
    
}

- (IBAction)trashPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneMeetingPressed:(id)sender {
    //TODO : get the meeting and upload the meeting to server
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
