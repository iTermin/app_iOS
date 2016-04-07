//
//  MeetingDateSelectorViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/17/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "UXDateCellsManager.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <AdSupport/ASIdentifierManager.h>

#import "MeetingDateSelectorViewController.h"
#import "ArrayOfCountries.h"
#import "MBProgressHUD.h"

#import "MainAssembly.h"


@interface MeetingDateSelectorViewController ()

{
    BOOL selectedAllDay;
}

@property (strong, nonatomic) UXDateCellsManager *dateCellsManager;
@property(nonatomic, strong) NSMutableSet * registeredNibs;

@end

@implementation MeetingDateSelectorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.meetingbusiness = [[MainAssembly defaultAssembly] meetingBusinessController];
    self.userbusiness = [[MainAssembly defaultAssembly] userBusinessController];
    
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

    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.arrayCountries = [ArrayOfCountries new];
    self.modelCountries = [self.arrayCountries getModelCountries];
    self.dateCurrent = [NSDate dateWithTimeInterval:0 sinceDate:startDate];
    self.userInformation = [NSDictionary dictionaryWithDictionary:[self getHourOfDate:self.dateCurrent]];
    selectedAllDay = NO;
    
    self.hoursArray = [NSMutableArray array];
    
    [self inputAlgoritm:startDate];
    
    [self getGuestsOfCurrentMeeting];
    
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
    [super viewWillAppear:YES];
    
    //BOOL bien = YES == self.dateCellsManager.allDay ? YES : NO;
}

- (void) getGuestsOfCurrentMeeting {
    NSMutableDictionary *detailMeeting = [NSMutableDictionary dictionary];
    [self.currentMeeting enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop) {
        [detailMeeting setDictionary:[self.currentMeeting valueForKey:key]];
    }];
    
    self.guestsOfMeeting = [NSArray arrayWithArray:detailMeeting[@"guests"]];
}

-(void) updateViewModel{
    NSMutableArray * viewModel = [NSMutableArray array];
    
    //TODO: change this section when implement algorithm
    int diferencialHour;
    if([self.hoursArray count]){
        NSArray *testHoursOutput = @[@20, @2, @3, @4, @5];
        diferencialHour = [self outputAlgoritm : testHoursOutput];
    }
    //

    [self.guestsOfMeeting enumerateObjectsUsingBlock:^(NSDictionary * guest, NSUInteger idx, BOOL * stop) {
        NSString * iconSelector = [NSString new];
        if (selectedAllDay == YES)
            iconSelector = @"allDay";
        else if (selectedAllDay == NO){
            NSNumber * totalHoursToAdd = [self getTotalHoursToAddTo: guest[@"codeCountry"] withIdentify:diferencialHour];
            NSNumber * actualGuestHour = [NSNumber numberWithInt:([totalHoursToAdd intValue] + [self.userInformation[@"hour"] intValue])];
            iconSelector = [self detectIconDepend:actualGuestHour];
        }
        
        NSMutableDictionary * cellModel = [NSMutableDictionary dictionaryWithDictionary:guest];
        [cellModel setObject:iconSelector forKey:@"selector"];
        
        [viewModel addObject:@{
                               @"nib" : @"GuestDateViewCell",
                               @"height" : @(70),
                               @"data":cellModel }];
    }];
    
    self.viewModel = viewModel;
    
    [self.tableView reloadData];
    
}


- (int) outputAlgoritm : (NSArray *) arrayHours {
    //TODO: input of self.hoursArray before removeAllObjects, implement with algoritm
    int subtract = 21 - [[@[@20, @2, @3, @4, @5] objectAtIndex:0] intValue];
    
    return [[NSNumber numberWithInt:subtract] intValue];
}

- (void) meetingAllDay: (BOOL) selected{
    selectedAllDay = selected;
    [self updateViewModel];
}

- (NSString *) detectIconDepend: (NSNumber *) hour {
    int dayHour = [hour intValue];
    
    if ([hour intValue] > 24) dayHour = [hour intValue] - 24;
    
    else if ([hour intValue] < 1) dayHour = [hour intValue] + 24;
    
    NSString * seccion = @"moon";
    
    for (int hourForDay = 1; hourForDay <= 24; ++hourForDay) {
        
        if (hourForDay == 5) seccion = @"sunsetMoon";
        else if (hourForDay == 10) seccion = @"sun";
        else if (hourForDay == 18) seccion = @"sunsetSun";
        else if (hourForDay == 21) seccion = @"moon";

        if (hourForDay == dayHour){
            return seccion;
            break;
        }
    }
    
    return @"";
}

- (NSNumber *) getTotalHoursToAddTo: (NSString *) guestCountry withIdentify: (int) hours{
    NSArray * UTCGuest  = [self getUTCGuest: guestCountry];
    NSArray * UTCUser = [self getUTCGuest:self.userInformation[@"countryCode"]];
    
    if(![UTCUser isEqualToArray:UTCGuest]){
        NSNumber * middleUTCUser = [UTCUser count]/2 == 0 ?
        [UTCUser objectAtIndex:[UTCUser count]/2] : [UTCUser objectAtIndex:[UTCUser count]/2 - 1];
        
        NSNumber * middleUTCGuest = [UTCGuest count]/2 == 0 ?
        [UTCGuest objectAtIndex:[UTCGuest count]/2] : [UTCGuest objectAtIndex:[UTCGuest count]/2 - 1];
        
        
        int differenceHourGuest = [middleUTCUser intValue] > 0 ?
        ([middleUTCGuest intValue] - [middleUTCUser intValue]) : ([middleUTCUser intValue] + [middleUTCGuest intValue]);
        
        return [NSNumber numberWithInt:differenceHourGuest];
    }
    
    return @0;
}

-(void) inputAlgoritm: (NSDate *) startDate {
    
    NSDictionary * userDate = self.userInformation;
    [self.hoursArray addObject:userDate[@"hour"]];
    
    [self.currentMeeting[@"guests"] enumerateObjectsUsingBlock:^(NSDictionary * guest, NSUInteger idx, BOOL * stop) {
        [self gethourGuest: guest[@"codeCountry"] respectUser:userDate];
    }];
    
    NSArray * prepareHours = [NSArray arrayWithArray:self.hoursArray];
    [self prepareHoursForAlgorithm: prepareHours];
}

- (void) prepareHoursForAlgorithm : (NSArray *) hours{
    [self.hoursArray removeAllObjects];
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

- (BOOL) isTheSameHourOf: (NSDate *) currentDate And: (NSDate*) dataCellDate {
    NSDateFormatter *hourFormatter = [NSDateFormatter new];
    hourFormatter.dateFormat = @"HH";
    
    NSString *currenHour = [hourFormatter stringFromDate: currentDate];
    NSString *currenDataCellHour = [hourFormatter stringFromDate: dataCellDate];
    
    return [currenHour isEqualToString:currenDataCellHour] ? YES : NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Date Cells
    if ([self.dateCellsManager isManagedDateCell:indexPath]) {
        if (![self isTheSameHourOf: self.dateCurrent And: self.dateCellsManager.startDate]) {
            self.dateCurrent = self.dateCellsManager.startDate;
            self.userInformation = [NSDictionary dictionaryWithDictionary:[self getHourOfDate:self.dateCurrent]];
            [self updateViewModel];
        }
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
        [self.dateCellsManager setSwitchCellData:self];
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
    
    UILabel * sectionHeader = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 280, 150)];
    sectionHeader.backgroundColor = [UIColor clearColor];
    
    return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (IBAction)sharePressed:(id)sender {
        
    NSMutableString *texttoshare = [NSMutableString stringWithFormat:@"You are invited to "];
    [texttoshare appendString:self.currentMeetingToUserDetail[@"name"]];
    //TODO : extract date and send url
    
    NSArray *activityItems = @[texttoshare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    [self presentViewController:activityVC animated:TRUE completion:nil];
    
}

- (IBAction)trashPressed:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Update...";
    hud.color = [UIColor lightGrayColor];
    [self validateCurrentMeetingWithSharedMeetings];
}

-(void) validateCurrentMeetingWithSharedMeetings {
    NSMutableDictionary * detailUser = [NSMutableDictionary dictionary];
    NSDictionary * sharedMeetings = [NSDictionary dictionary];
    
    [self.userbusiness updateUserWithCallback:^(id<IUserDatasource>handler) {
        [detailUser setDictionary: [handler getUser]];
        [detailUser enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop) {
            if ([key isEqualToString:@"sharedMeetings"]) {
                [sharedMeetings setValuesForKeysWithDictionary:detailUser[@"sharedMeetings"]];
            }
        }];
        
        if ([sharedMeetings count]) {
            [self currentMeetingInSharedMeetings:sharedMeetings];
        } else {
            [self cleanCurrentMeeting];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void) currentMeetingInSharedMeetings: (NSDictionary *) meetings{
    [meetings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop) {
        NSLog(@"%@", key);
    }];
}

- (void) cleanCurrentMeeting{
    [self.currentMeetingToUserDetail setDictionary:@{
                                                     @"date": @"init",
                                                     @"meeingId": self.currentMeetingToUserDetail[@"meetingId"],
                                                     @"name": @"init"
                                                     }];
    [self.userbusiness updateCurrentMeetingToUser:self.currentMeetingToUserDetail];
    
    [self.currentMeeting setDictionary:@{
                                         [[self.currentMeeting allKeys] objectAtIndex:0] : @{
                                                 @"detail" : [NSMutableDictionary dictionaryWithObjectsAndKeys:@"init", @"init", nil],
                                                 @"guests" : [NSMutableArray arrayWithObjects:@"init", nil],
                                                 }
                                         }];
    [self.meetingbusiness updateNewMeeting:self.currentMeeting];
}

- (IBAction)doneMeetingPressed:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Update...";
    hud.color = [UIColor lightGrayColor];
    
    [self updateMeetings:YES];
    [self.meetingbusiness updateNewMeeting:self.currentMeeting];
    [self.currentMeetingToUserDetail setDictionary:@{}];
    [self.userbusiness updateCurrentMeetingToUser:self.currentMeetingToUserDetail];
    [self updateDetailOfUser];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString*) getDeviceId{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

- (void) updateMeetings: (BOOL) activeMeeting{
    
    [self updateCurrentMeeting:activeMeeting];
    [self updateCurrentMeetingToUserDetail];
    
}

- (void) updateCurrentMeetingToUserDetail{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss ZZZZ"];
    NSString *start = [dateFormatter stringFromDate:self.dateCellsManager.startDate];
    [self.currentMeetingToUserDetail setValue:start forKey:@"date"];
}

-(void) updateCurrentMeeting: (BOOL) activeMeeting{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss ZZZZ"];
    NSString *start = [dateFormatter stringFromDate:self.dateCellsManager.startDate];
    NSString *end = [dateFormatter stringFromDate:self.dateCellsManager.endDate];
    
    NSMutableDictionary * meeting = [NSMutableDictionary dictionary];
    [self.currentMeeting enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop) {
        [meeting setDictionary:[NSMutableDictionary
                                dictionaryWithDictionary:[self.currentMeeting valueForKey:key]]];
        [meeting setValue:[NSMutableDictionary dictionaryWithDictionary:@{
                                                                          @"name": self.currentMeetingToUserDetail[@"name"],
                                                                          @"active": activeMeeting ? @YES : @NO,
                                                                          @"startDate": start,
                                                                          @"endDate" : end,
                                                                          @"creator" : [self getDeviceId],
                                                                          @"notifications" : @{
                                                                                  @"apn" : @NO,
                                                                                  @"calendar" : @{
                                                                                          @"idEvent": @"init",
                                                                                          @"state": @NO,
                                                                                          },
                                                                                  @"email" : @NO,
                                                                                  @"reminder" : @NO
                                                                                  },
                                                                          }] forKey:@"detail"];
        
        [meeting setValue:self.guestsOfMeeting forKey:@"guests"];
        
        [meeting setDictionary:[NSMutableDictionary
                                dictionaryWithDictionary:@{
                                                           key: [NSMutableDictionary dictionaryWithDictionary:meeting]
                                                           }]];
    }];
    [self.currentMeeting setDictionary:meeting];
}

- (void) updateDetailOfUser{
    [self.userbusiness updateUserWithCallback:^(id<IUserDatasource>handler) {
        NSMutableDictionary * detailUser = [NSMutableDictionary
                                            dictionaryWithDictionary:
                                            [handler getUser]];
        
        [self.userbusiness updateInformationUserWithNewMeeting:
        [self modifyInformationUser:detailUser]];
    }];
}

- (NSDictionary *) modifyInformationUser: (NSMutableDictionary *) detailUser{
    if ([detailUser[@"activeMeetings"] count])
        [detailUser[@"activeMeetings"] addObject:
         [NSDictionary dictionaryWithDictionary:self.currentMeetingToUserDetail]];
    else
        [detailUser setObject:self.currentMeetingToUserDetail forKey:@"activeMeetings"];
    
    return [NSDictionary dictionaryWithDictionary:detailUser];
    
}

@end
