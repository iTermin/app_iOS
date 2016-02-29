//
//  MeetingBeginViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 12/28/15.
//  Copyright © 2015 Estefania Chavez Guardado. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "BeginMeetingViewController.h"
#import "MeetingDateSelectorViewController.h"
#import "EditGuestDetailViewController.h"

@interface BeginMeetingViewController () < ABPeoplePickerNavigationControllerDelegate,ABPersonViewControllerDelegate>
{
    BOOL changedInformation;
}

@end

@implementation BeginMeetingViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self updateViewModel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listOfGuests = [NSMutableArray array];
    self.listOfGuests = self.currentMeeting[@"guests"];

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
    
    self.dataModelCountries = @{
                                @"countries" : @[
                                        @{
                                            @"name": @"China",
                                            @"dial_code": @"+86",
                                            @"code": @"CN"
                                            },
                                        @{
                                            @"name": @"France",
                                            @"dial_code": @"+33",
                                            @"code": @"FR"
                                            },
                                        @{
                                            @"name": @"Germany",
                                            @"dial_code": @"+49",
                                            @"code": @"DE"
                                            },
                                        @{
                                            @"name": @"India",
                                            @"dial_code": @"+91",
                                            @"code": @"IN"
                                            },
                                        @{
                                            @"name": @"Italy",
                                            @"dial_code": @"+39",
                                            @"code": @"IT"
                                            },
                                        @{
                                            @"name": @"Japan",
                                            @"dial_code": @"+81",
                                            @"code": @"JP"
                                            },
                                        @{
                                            @"name": @"Mexico",
                                            @"dial_code": @"+52",
                                            @"code": @"MX"
                                            },
                                        @{
                                            @"name": @"United Kingdom",
                                            @"dial_code": @"+44",
                                            @"code": @"GB"
                                            },
                                        @{
                                            @"name": @"United States",
                                            @"dial_code": @"+1",
                                            @"code": @"US"
                                            }
                                        ]};
    
    self.emailGuest.delegate = self;
    self.nameMeeting.delegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"guest"];
}

- (void) updateViewModel {
    
    NSMutableArray * viewModel = [NSMutableArray array];
    [self.listOfGuests enumerateObjectsUsingBlock:^(NSDictionary * guests, NSUInteger idx, BOOL * stop) {
        
        NSMutableDictionary * cellModel = [NSMutableDictionary dictionaryWithDictionary:guests];
        
        UIImage * contactPhoto = [UIImage imageNamed:
                                  [NSString stringWithFormat:@"%@.png",
                                   guests[@"photo"]]];
        if(contactPhoto) [cellModel setObject:contactPhoto forKey:@"contactPhoto"];
        
        [viewModel addObject:@{
                               @"nib" : @"GuestViewCellCountry",
                               @"height" : @(60),
                               @"segue" : @"editGuestDetails",
                               @"data":cellModel }];
    }];
    
    self.viewModel = viewModel;
    
    if (changedInformation){
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.indexPathGuestSelected.row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        changedInformation = NO;
    }
    
    [super updateViewModel];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL validate = NO;
    if (textField == self.emailGuest) {
        [textField resignFirstResponder];
        validate = [self validateEmail:self.emailGuest.text];
        if(validate){
            [self addNewGuestWith:self.emailGuest.text];
            textField.text = nil;
            return validate;
        } else{
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"Wrong Email!"
                                        message:@"The email is incorrect. Please enter the correct email (email@gmail.com)."
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
        }
    }
    if (textField == self.nameMeeting) {
        [textField resignFirstResponder];
        NSString *nameMeeting = self.nameMeeting.text;
        NSLog(@"%@", nameMeeting);
    }
    return validate;
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

-(void)addNewGuestWith:(NSString *)email{

    NSMutableDictionary * guestInformation = [NSMutableDictionary dictionaryWithDictionary: @{
                                            @"photo" : @"",
                                            @"codePhone" : @"",
                                            @"email" : email,
                                            @"name" : @""
                                                                                              }];
    NSString * code = [self getFlagCodeWithCodePhoneGuest:guestInformation[@"codePhone"]];
    
    [guestInformation setObject:code forKey:@"codeCountry"];
    
    [self.listOfGuests addObject: guestInformation];
    [self updateViewModel];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.listOfGuests count] - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];

}

- (IBAction)searchContacts:(id)sender {
    switch (ABAddressBookGetAuthorizationStatus())
    {
            // Update our UI if the user has granted access to their Contacts
        case  kABAuthorizationStatusAuthorized:
            [self accessGrantedForAddressBook];
            break;
            // Prompt the user for access to Contacts if there is no definitive answer
        case  kABAuthorizationStatusNotDetermined :
            [self requestAddressBookAccess];
            break;
            // Display a message if the user has denied or restricted access to Contacts
        case  kABAuthorizationStatusDenied:
        case  kABAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning"
                                                            message:@"Permission was not granted for Contacts."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}

-(void)requestAddressBookAccess
{
    BeginMeetingViewController * __weak weakSelf = self;
    
    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error)
                                             {
                                                 if (granted)
                                                 {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [weakSelf accessGrantedForAddressBook];
                                                         
                                                     });
                                                 }
                                             });
}

-(void)accessGrantedForAddressBook
{
    // Load data from the plist file
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"plist"];
    self.menuArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    [self showPeoplePickerController];
    
    //[self.tableView reloadData];
}

-(void)showPeoplePickerController
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    // Display only a person's phone, email, and birthdate
    NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
                               [NSNumber numberWithInt:kABPersonEmailProperty],
                               [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];
    
    
    picker.displayedProperties = displayedItems;
    // Show the picker
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person {
    
    NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    
    NSString *middleName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonMiddleNameProperty));
    
    NSString *lastName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
    
    ABMutableMultiValueRef multiEmail = ABRecordCopyValue(person, kABPersonEmailProperty);
    NSString *email = (__bridge NSString *) ABMultiValueCopyValueAtIndex(multiEmail, 0);
    
    ABMultiValueRef phoneNumberProperty = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSArray *phoneNumbers = (__bridge NSArray*)ABMultiValueCopyArrayOfAllValues(phoneNumberProperty);
    
    UIImage *retrievedImage;
    if (person != nil && ABPersonHasImageData(person))
    {
        retrievedImage = [UIImage imageWithData:(__bridge_transfer NSData*)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail)];
    }
    else
    {
        retrievedImage = nil;
    }
    
    NSString *retrievedName;
    
    if (firstName != NULL && middleName != NULL && lastName != NULL)
    {
        retrievedName = [[NSString alloc] initWithFormat:@"%@ %@ %@",firstName,middleName,lastName];
    }
    
    if (firstName != NULL && middleName != NULL & lastName == NULL)
    {
        retrievedName = [[NSString alloc] initWithFormat:@"%@ %@",firstName, middleName];
    }
    
    if (firstName != NULL && middleName == NULL && lastName != NULL)
    {
        retrievedName = [[NSString alloc] initWithFormat:@"%@ %@",firstName,lastName];
    }
    
    if (firstName != NULL && middleName == NULL && lastName == NULL)
    {
        retrievedName = [[NSString alloc] initWithFormat:@"%@",firstName];
    }
    
    if (firstName == NULL && middleName != NULL && lastName != NULL)
    {
        retrievedName = [[NSString alloc] initWithFormat:@"%@ %@",middleName, lastName];
    }
    
    if (firstName == NULL && middleName != NULL && lastName == NULL)
    {
        retrievedName = [[NSString alloc] initWithFormat:@"%@",middleName];
    }
    
    if (firstName == NULL && middleName == NULL && lastName != NULL)
    {
        retrievedName = [[NSString alloc] initWithFormat:@"%@", lastName];
    }
    
    [self addName:retrievedName phone:phoneNumbers email:email photoToViewModel:retrievedImage];
    
    [self dismissViewControllerAnimated:NO completion:^(){}];
}

-(void) addName: (NSString *) nameGuest phone:(NSArray *)phoneGuest email:(NSString *)emailGuest photoToViewModel:(UIImage *)photoContact{

    NSString *codeContact = [self codePhone:phoneGuest];
    NSString * code = [self getFlagCodeWithCodePhoneGuest:codeContact];

    NSMutableDictionary * guestInformation = [NSMutableDictionary dictionaryWithDictionary: @{
                                        @"photo" : photoContact ? photoContact : @"",
                                        @"codePhone" : codeContact ? codeContact : @"",
                                        @"email" : emailGuest ? emailGuest : @"", //TODO: Alerta que no tiene correo electronico
                                        @"name" : nameGuest,
                                        @"codeCountry" : code
    }];
    
    [self.listOfGuests addObject:guestInformation];
    [self updateViewModel];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.listOfGuests count] - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

-(NSString *) codePhone:(NSArray *)phone{
    NSInteger numberOfPhones = phone.count;
    NSString *codeCountry = @"";
    BOOL existOneCodeCountry = false;
    
    if (numberOfPhones != 0) {
        while (numberOfPhones > 0 && existOneCodeCountry == false) {
            NSString *phoneNumber = phone[numberOfPhones-1];
            NSMutableArray *numberPhoneArray = [NSMutableArray array];
            for (int lenghtOfNumberPhone=0; lenghtOfNumberPhone<phoneNumber.length; ++lenghtOfNumberPhone) {
                [numberPhoneArray addObject:[phoneNumber substringWithRange:NSMakeRange(lenghtOfNumberPhone, 1)]];
            }
            NSString *space = @" ";
            for (int lengthNumberPhone = 0; lengthNumberPhone < numberPhoneArray.count; ++lengthNumberPhone) {
                if ([numberPhoneArray[0] isEqual:@"+"]) {
                    existOneCodeCountry = true;
                    if (![numberPhoneArray[lengthNumberPhone] isEqual:@"("] & ![numberPhoneArray[lengthNumberPhone] isEqual:@")"] & ![numberPhoneArray[lengthNumberPhone] isEqual:space]){
                        NSString *digit = numberPhoneArray[lengthNumberPhone];
                        codeCountry = [codeCountry stringByAppendingString:digit];
                    } else {
                        break;
                    }
                } else {
                    return codeCountry;
                }
            }
            --numberOfPhones;
        }
    } else {
        return codeCountry;
    }
    
    return codeCountry;
}

-(NSString *) getCountryUser {
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    return countryCode;
}

- (NSString *)getFlagCodeWithCodePhoneGuest:(NSString *)codePhone {
    NSString *codeContact = codePhone;
    NSString * code = @"";
    
    if([codeContact isEqualToString:code]){
        return code = [self getCountryUser];
    } else{
        NSDictionary *countriesInformation = self.dataModelCountries[@"countries"];
        NSDictionary * element;
        
        for (element in countriesInformation) {
            NSString * dial_code = element[@"dial_code"];
            if ([dial_code isEqualToString: codeContact]) {
                return code = element[@"code"];
            }
        }
        return code;
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSMutableDictionary *)sender {
    if ([segue.identifier isEqualToString:@"editGuestDetails"]){
        EditGuestDetailViewController * editGuestDetailViewController = (EditGuestDetailViewController *)segue.destinationViewController;
        [editGuestDetailViewController setCurrentGuest: sender];
        [editGuestDetailViewController setGuestInformationDelegate:self];
        
    } else if ([segue.identifier isEqualToString:@"setMeeting"]){
        MeetingDateSelectorViewController *meetingDateSelectorViewController = (MeetingDateSelectorViewController *)segue.destinationViewController;
        //SetMeetingViewController * guestDateMeetingViewController = (SetMeetingViewController *)segue.destinationViewController;
        NSMutableArray *guestList = self.listOfGuests;
        [meetingDateSelectorViewController setGuestMeeting: guestList];
    }
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
            
        } else if([self.nameMeeting.text isEqualToString:@""]){
            self.nameMeeting.text = @"Meeting 1";
            return true;
            
        } else{
            return true;
        }
    }
    return true;
}

@end