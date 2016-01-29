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
#import "SetMeetingViewController.h"

@interface BeginMeetingViewController () < ABPeoplePickerNavigationControllerDelegate,ABPersonViewControllerDelegate>

@property (nonatomic, assign) ABAddressBookRef addressBook;
@property (nonatomic, strong) NSMutableArray *menuArray;

@end

@implementation BeginMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CALayer *nameBorder = [CALayer layer];
    nameBorder.frame = CGRectMake(0.0f, self.nameMeeting.frame.size.height - 1, self.nameMeeting.frame.size.width, 1.0f);
    nameBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.nameMeeting.layer addSublayer:nameBorder];
    
    CALayer *guestBorder = [CALayer layer];
    guestBorder.frame = CGRectMake(0.0f, self.nameGuest.frame.size.height - 1, self.nameGuest.frame.size.width, 1.0f);
    guestBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.nameGuest.layer addSublayer:guestBorder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
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

- (IBAction)inviteGuests:(id)sender {
    
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
    NSString *email = CFBridgingRelease(ABMultiValueCopyLabelAtIndex(multiEmail, 0));
    
    ABMultiValueRef phoneNumberProperty = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSArray *phoneNumbers = CFBridgingRelease(ABMultiValueCopyArrayOfAllValues(phoneNumberProperty));
    
    if (person != nil && ABPersonHasImageData(person))
    {
        UIImage *retrievedImage = [UIImage imageWithData:(__bridge_transfer NSData*)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail)];
    }
    else
    {
        UIImage *retrievedImage = nil;
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
    
    [self dismissViewControllerAnimated:NO completion:^(){}];
}

@end