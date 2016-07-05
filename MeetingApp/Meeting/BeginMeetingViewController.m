//
//  MeetingBeginViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 12/28/15.
//  Copyright © 2015 Estefania Chavez Guardado. All rights reserved.
//

#import <SWTableViewCell.h>

#import "BeginMeetingViewController.h"
#import "MeetingDateSelectorViewController.h"
#import "EditGuestDetailViewController.h"
#import "ArrayOfCountries.h"
#import "MainAssembly.h"

@interface BeginMeetingViewController () <CNContactPickerDelegate, CNContactViewControllerDelegate>
{
    BOOL changedInformation;
}

@end

@implementation BeginMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.meetingbusiness = [[MainAssembly defaultAssembly] meetingBusinessController];
    self.userbusiness = [[MainAssembly defaultAssembly] userBusinessController];
    self.pickerAddress = [[MainAssembly defaultAssembly] contactAddress];
    self.pickerAddress.viewController = self;
    self.pickerAddress.contactInformation = self;
    
    self.listOfGuests = [NSMutableArray array];
    
    [self verifyDataOfCurrentMeeting];
    
    self.indexPathGuestSelected = [NSIndexPath new];
    
    CGSize nameSize = self.nameMeeting.frame.size;
    CGFloat xPosition = 0.0f;
    CGFloat yPosition = 1.0f;
    UIColor *grayColorSeparator = [UIColor colorWithWhite: 0.70 alpha:1];
    
    CALayer *nameBorder = [CALayer layer];
    nameBorder.frame = CGRectMake(xPosition, nameSize.height - 1, nameSize.width, yPosition);
    nameBorder.backgroundColor = grayColorSeparator.CGColor;
    [self.nameMeeting.layer addSublayer:nameBorder];
    
    CALayer *guestBorder = [CALayer layer];
    CGSize meetingSize = self.nameMeeting.frame.size;
    guestBorder.frame = CGRectMake(xPosition, meetingSize.height - 1, meetingSize.width, yPosition);
    guestBorder.backgroundColor = grayColorSeparator.CGColor;
    [self.emailGuest.layer addSublayer:guestBorder];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.arrayCountries = [ArrayOfCountries new];
    self.modelCountries = [self.arrayCountries getModelCountries];
    
    self.emailGuest.delegate = self;
    self.nameMeeting.delegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.addContactAddress addGestureRecognizer:tapRecognizer];
    
    UIGestureRecognizer * tapper = [[UITapGestureRecognizer alloc]
                                  initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    [self updateViewModel];
}

- (void) verifyDataOfCurrentMeeting{
    [self.currentMeeting enumerateKeysAndObjectsUsingBlock:^(id key, NSDictionary * meeting, BOOL * stop) {
        if (![[meeting[@"guests"] objectAtIndex:0] isKindOfClass:[NSString class]]) {
            self.listOfGuests = [NSMutableArray arrayWithArray:meeting[@"guests"]];
        }
        
        NSString * nameMeeting = [NSString stringWithString:self.currentMeetingToUserDetail[@"name"]];
        if (![nameMeeting isEqualToString:@"init"]) {
            self.nameMeeting.text = nameMeeting;
        }
    }];
    
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"guest"];
}

- (void) updateViewModel {
    
    NSMutableArray * viewModel = [NSMutableArray array];
    __block NSDictionary * detailUser = [NSDictionary dictionaryWithDictionary:[self.userbusiness getUser]];
    
    [self.listOfGuests enumerateObjectsUsingBlock:^(NSDictionary * guests, NSUInteger idx, BOOL * stop) {
        
        if (![self existUser:detailUser AsGuest:guests]) {
            NSMutableDictionary * cellModel = [NSMutableDictionary dictionaryWithDictionary:guests];
            
            UIImage * contactPhoto = [UIImage imageNamed:
                                      [NSString stringWithFormat:@"%@.png",
                                       guests[@"photo"]]];
            if(contactPhoto) [cellModel setObject:contactPhoto forKey:@"contactPhoto"];
            
            [viewModel addObject:@{
                                   @"nib" : @"GuestViewCellCountry",
                                   @"height" : @(70),
                                   @"segue" : @"editGuestDetails",
                                   @"data":cellModel }];
        }
    }];
    
    self.viewModel = [NSArray arrayWithArray:viewModel];
    
    if (changedInformation){
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.indexPathGuestSelected.row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        changedInformation = NO;
    }
    
    [super updateViewModel];
}

- (BOOL) existUser:(NSDictionary *) userDetail AsGuest:(NSDictionary *) guestDetail {
    BOOL existUser = NO;
    if ([[userDetail valueForKey:@"email"] isEqualToString:[guestDetail valueForKey:@"email"]]) {
        existUser = YES;
    }
    return existUser;
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL guestIsValid = NO;
    if (textField == self.emailGuest) {
        [textField resignFirstResponder];
        if (![self.emailGuest.text isEqualToString:@""]) {
            guestIsValid = [self validateEmail:self.emailGuest.text];
            if(guestIsValid){
                BOOL isDiferentGuest = [self isDiferentGuest: @{ @"email" : self.emailGuest.text }];
                if (isDiferentGuest) {
                    [self addNewGuestWith:self.emailGuest.text];
                    textField.text = nil;
                    return guestIsValid;
                }
                else{
                    [self alertGuestRegistered];
                    return guestIsValid = NO;
                }
            } else{
                UIAlertController *alert = [UIAlertController
                                            alertControllerWithTitle:@"Wrong Email!"
                                            message:@"The email is incorrect. Please enter the correct email (email@gmail.com)."
                                            preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                     }];
                
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
    if (textField == self.nameMeeting)
        [textField resignFirstResponder];
    
    return guestIsValid;
}

- (void) alertGuestRegistered{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"The guest has already been added."
                                message:@"You had registered a guest with the same information."
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action){
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL) validateEmail:(NSString*) emailAddress{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self.emailGuest.text];
    //ref:http://stackoverflow.com/a/22344769/5757715
}

- (BOOL) isDiferentGuest: (NSDictionary *) information{
    __block BOOL isDiferentGuest = YES;
    
    [self.listOfGuests enumerateObjectsUsingBlock:^(NSDictionary * registerdGuests, NSUInteger idx, BOOL * stop){
        if ([registerdGuests[@"email"] isEqualToString:information[@"email"]])
            if ([information[@"email"] length])
                isDiferentGuest = NO;
        
        if (isDiferentGuest)
            if ([registerdGuests[@"name"] isEqualToString:information[@"name"]])
                isDiferentGuest =  NO;
    }];
    return isDiferentGuest;
}

-(void)addNewGuestWith:(NSString *)email{

    NSMutableDictionary * guestInformation = [NSMutableDictionary dictionaryWithDictionary: @{
                                            @"photo" : @"",
                                            @"email" : email,
                                            @"name" : @"",
                                            @"codeCountry" : [self getCodeCountryUser]
                                                                                              }];
    
    [self.listOfGuests addObject: guestInformation];
    [self updateViewModel];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.listOfGuests count] - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];

}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self.pickerAddress contactScan];
}

- (void)getContactSelected:(NSDictionary *)contactInformation{
    if ([self isDiferentGuest:contactInformation])
        [self addGuest:[NSMutableDictionary dictionaryWithDictionary:contactInformation]];
    else
        [self alertGuestRegistered];
}

-(void) addGuest: (NSMutableDictionary *) guestInfo {
    
    NSArray *codeContact = [self codesCountriesWith:guestInfo[@"phone"]];
    NSString * code = [self getFlagCodeWithCodePhoneGuest:codeContact];
    
    [guestInfo setValue:code forKey:@"codeCountry"];
    
    [self.listOfGuests addObject:guestInfo];

    [self updateViewModel];
        
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.listOfGuests count] - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    if ([guestInfo[@"email"] isEqualToString:@""])
        [self warningRegisterEmailGuest:guestInfo[@"name"]];
}

- (void) warningRegisterEmailGuest: (NSMutableString *) nameGuest{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Incomplete information."
                                message: [nameGuest stringByAppendingString:@" hasn´t registered email."]
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action){
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

-(NSArray *) codesCountriesWith:(NSArray *)phone{
    NSInteger numberOfPhones = phone.count;
    NSString *codeCountry = @"";
    BOOL existOneCodeCountry = false;
    NSMutableArray * codesCountries = [NSMutableArray arrayWithArray:@[]];
    
    if (numberOfPhones != 0) {
        while (numberOfPhones > 0 && existOneCodeCountry == false) {
            NSString *phoneNumber = phone[numberOfPhones-1];
            NSMutableArray *numberPhoneArray = [NSMutableArray array];
            for (int lenghtOfNumberPhone=0; lenghtOfNumberPhone<phoneNumber.length; ++lenghtOfNumberPhone) {
                [numberPhoneArray addObject:[phoneNumber substringWithRange:NSMakeRange(lenghtOfNumberPhone, 1)]];
            }
            NSString *space = @" ";
            BOOL allCodePhones = NO;
            for (int lengthNumberPhone = 0; lengthNumberPhone < numberPhoneArray.count; ++lengthNumberPhone) {
                if ([numberPhoneArray[0] isEqual:@"+"]) {
                    existOneCodeCountry = true;
                    if (![numberPhoneArray[lengthNumberPhone] isEqual:@"("] & ![numberPhoneArray[lengthNumberPhone] isEqual:@")"] & ![numberPhoneArray[lengthNumberPhone] isEqual:space]){
                        NSString *digit = numberPhoneArray[lengthNumberPhone];
                        codeCountry = [codeCountry stringByAppendingString:digit];
                        switch (codeCountry.length) {
                            case 2:
                                [codesCountries addObject:codeCountry];
                                break;
                            case 3:
                                [codesCountries addObject:codeCountry];
                                break;
                            case 4:
                                [codesCountries addObject:codeCountry];
                                allCodePhones = YES;
                                break;
                            default:
                                break;
                        }
                    } else {
                        break;
                    }
                } else {
                    return codesCountries;
                }
                if (allCodePhones == YES)
                    break;
            }
            --numberOfPhones;
        }
    } else {
        return codesCountries;
    }
    
    return codesCountries;
}

-(NSString *) getCodeCountryUser {
    NSDictionary *detailUser = [NSDictionary dictionaryWithDictionary:[self.userbusiness getUser]];

    return detailUser[@"code"];
}

- (NSString *)getFlagCodeWithCodePhoneGuest:(NSArray *)codePhone {
    __block NSString * code = [NSString new];

    if (![codePhone count]) {
        code = [self getCodeCountryUser];
    } else{
        [codePhone enumerateObjectsUsingBlock:^(id codePhone, NSUInteger idx, BOOL * stop){
            NSArray *countriesInformation = self.modelCountries;
            NSDictionary * element;
            
            for (element in countriesInformation) {
                NSString * dial_code = element[@"dial_code"];
                if ([dial_code isEqualToString: codePhone])
                    code = element[@"code"];
            }
        }];
    }

    return code;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    [self performSegue: indexPath];
    self.indexPathGuestSelected = indexPath;
}

- (void) guestInformation: (id<IGuestInformation>) guestDetail
    didChangedInformation: (NSDictionary *) guest{
    changedInformation = YES;
    [self.listOfGuests replaceObjectAtIndex:self.indexPathGuestSelected.row withObject:guest];
    [self updateViewModel];
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

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            [self.listOfGuests removeObjectAtIndex:cellIndexPath.row];
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

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

- (IBAction)nextPressed:(id)sender {
    if(![self.viewModel isEqualToArray:@[]] && [self allGuestHadEmail])
        if ([self.nameMeeting.text isEqualToString:@""]) self.nameMeeting.text = @"Meeting 1";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSMutableDictionary *)sender {
    if ([segue.identifier isEqualToString:@"editGuestDetails"]){
        EditGuestDetailViewController * editGuestDetailViewController = (EditGuestDetailViewController *)segue.destinationViewController;
        [editGuestDetailViewController setCurrentGuest: sender];
        [editGuestDetailViewController setGuestInformationDelegate:self];
        
    } else if ([segue.identifier isEqualToString:@"setMeeting"]){
        MeetingDateSelectorViewController *meetingDateSelectorViewController =
            (MeetingDateSelectorViewController *)segue.destinationViewController;
        
        [self.currentMeetingToUserDetail setValue:self.nameMeeting.text forKey:@"name"];
        [self.userbusiness updateCurrentMeetingToUser:self.currentMeetingToUserDetail];
        
        NSMutableDictionary * meeting = [NSMutableDictionary dictionary];
        [self.currentMeeting enumerateKeysAndObjectsUsingBlock:^(NSString * key, id obj, BOOL * stop) {
            [meeting setDictionary:[NSMutableDictionary
                                     dictionaryWithDictionary:self.currentMeeting[key]]];
            
            if ([meeting[@"detail"] count] < 2) {
                [meeting setValue:[NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  @"name" : self.nameMeeting.text,
                                                                                }] forKey:@"detail"];
            }
            
            [self clearInformationOfGuests];
            [meeting setValue:self.listOfGuests forKey:@"guests"];
            
            [meeting setDictionary:[NSMutableDictionary dictionaryWithDictionary:@{
                                                                                   key: [NSMutableDictionary dictionaryWithDictionary:meeting]
                                                                                   }]];
        }];
        
        [self.currentMeeting setDictionary:meeting];
        [self.meetingbusiness updateNewMeeting:self.currentMeeting];

        [meetingDateSelectorViewController setTitle:self.nameMeeting.text];
        [meetingDateSelectorViewController setCurrentMeeting:self.currentMeeting];
        [meetingDateSelectorViewController setCurrentMeetingToUserDetail:self.currentMeetingToUserDetail];
    }
}

- (void) clearInformationOfGuests{
    __block NSDictionary * detailUser = [NSDictionary dictionaryWithDictionary:[self.userbusiness getUser]];
    __block NSMutableArray * guestInformation = [NSMutableArray array];
    
    [self.listOfGuests enumerateObjectsUsingBlock:^(NSMutableDictionary * guest, NSUInteger idx, BOOL * stop) {
        if (![self existUser:detailUser AsGuest:guest]) {
            NSMutableDictionary * tempGuest = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                    @"codeCountry": guest[@"codeCountry"],
                                                                    @"email": guest[@"email"],
                                                                    @"name": guest[@"name"],
                                                                    @"photo": guest[@"photo"],
                                                                    @"status": @0
                                                                    }];
            [guestInformation addObject:tempGuest];
        } else{
            [guestInformation addObject:guest];
        }
    }];
    
    [self.listOfGuests removeAllObjects];
    [self.listOfGuests addObjectsFromArray:guestInformation];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"setMeeting"]){
        if([self.viewModel isEqualToArray:@[]]){
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"Invite Guest!"
                                        message:@"You need add guest to the meeting."
                                        preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action){
                                     //Do some thing here
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
            
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            return false;
            
        } else if (![self allGuestHadEmail]){
            [self needRegisterEmailGuest];
            return false;
            
        } else return true;
        
    }
    return true;
}

- (BOOL) allGuestHadEmail {
    __block int manyGuestHaveEmail = 0;
    
    [self.listOfGuests enumerateObjectsUsingBlock:^(NSDictionary * registerdGuests, NSUInteger idx, BOOL * stop){
        manyGuestHaveEmail = [registerdGuests[@"email"] isEqualToString: @""] ? manyGuestHaveEmail + 1 : manyGuestHaveEmail;
    }];
    BOOL allOfGuestHaveEmail = YES;
    
    return allOfGuestHaveEmail = manyGuestHaveEmail > 0 ? NO : YES;
}

- (void) needRegisterEmailGuest{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Require Information."
                                message:@"It´s necesary add the email for all the guests."
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action){
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end