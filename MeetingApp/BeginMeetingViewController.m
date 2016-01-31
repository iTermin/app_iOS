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
#import "EditGuestDetailViewController.h"

@interface BeginMeetingViewController () < ABPeoplePickerNavigationControllerDelegate,ABPersonViewControllerDelegate>

@property (nonatomic, assign) ABAddressBookRef addressBook;
@property (nonatomic, strong) NSMutableArray *menuArray;

- (BOOL)validateEmail:(NSString*) emailAddress ;

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
    
    self.guestsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dataModelCountries = @{
                                @"countries" : @[
                                        @{
                                            @"name": @"China",
                                            @"dial_code": @"(86)",
                                            @"code": @"CN"
                                            },
                                        @{
                                            @"name": @"France",
                                            @"dial_code": @"(33)",
                                            @"code": @"FR"
                                            },
                                        @{
                                            @"name": @"Germany",
                                            @"dial_code": @"(49)",
                                            @"code": @"DE"
                                            },
                                        @{
                                            @"name": @"India",
                                            @"dial_code": @"(91)",
                                            @"code": @"IN"
                                            },
                                        @{
                                            @"name": @"Italy",
                                            @"dial_code": @"(39)",
                                            @"code": @"IT"
                                            },
                                        @{
                                            @"name": @"Japan",
                                            @"dial_code": @"(81)",
                                            @"code": @"JP"
                                            },
                                        @{
                                            @"name": @"Mexico",
                                            @"dial_code": @"(52)",
                                            @"code": @"MX"
                                            },
                                        @{
                                            @"name": @"United Kingdom",
                                            @"dial_code": @"(44)",
                                            @"code": @"GB"
                                            },
                                        @{
                                            @"name": @"United States",
                                            @"dial_code": @"(1)",
                                            @"code": @"US"
                                            }
                                        ]};
    
    self.dataModel = [NSMutableArray arrayWithArray:@[
      @{
          @"name": @"Luis Alejandro Rangel",
          @"phone": @"(86)",
          @"email": @"email@correo.mx",
          @"photo": @"fondo"
          },
      @{
          @"name": @"Jesus Cagide",
          @"phone": @"(86)",
          @"email": @"email@correo.mx",
          @"photo": @""
          }
      ]];
    
    [self updateViewModel];
    
    __weak UITableView * tableView = self.guestsTableView;
    NSMutableSet * registeredNibs = [NSMutableSet set];
    
    [self.viewModel enumerateObjectsUsingBlock:^(NSDictionary * cellViewModel, NSUInteger idx, BOOL * stop) {
        
        NSString * nibFile = cellViewModel[@"nib"];
        
        if(![registeredNibs containsObject: nibFile]) {
            [registeredNibs addObject: nibFile];
            
            UINib * nib = [UINib nibWithNibName:nibFile bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:nibFile];
        }
    }];
    
    self.nameGuest.delegate = self;
}

-(void) detectCountryOfGuest:(NSDictionary *)guestInformation{

}

- (void) updateViewModel {
    NSMutableArray * viewModel = [NSMutableArray array];
    [self.dataModel enumerateObjectsUsingBlock:^(NSDictionary * guests, NSUInteger idx, BOOL * stop) {
        
        NSMutableDictionary * cellModel = [NSMutableDictionary dictionaryWithDictionary:guests];
        
        UIImage * contactPhoto = [UIImage imageNamed: [NSString stringWithFormat:@"%@.png", guests[@"photo"]]];
        if(contactPhoto) [cellModel setObject:contactPhoto forKey:@"contactPhoto"];
        
        [viewModel addObject:@{
                               @"nib" : @"GuestViewCell",
                               @"height" : @(60),
                               @"data":cellModel }];
    }];
    
    self.viewModel = viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameGuest) {
        [textField resignFirstResponder];
        BOOL validate = [self validateEmail:self.nameGuest.text];
        return NO;
    }
    return YES;
}

- (BOOL) validateEmail:(NSString*) emailAddress{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self.nameGuest.text];
    //ref:http://stackoverflow.com/a/22344769/5757715
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
    NSDictionary * guestInformation = @{
                                        @"photo" : photoContact ? photoContact : @"",
                                        @"phone" : phoneGuest,
                                        @"email" : emailGuest,
                                        @"name" : nameGuest
    };
    
    [self.dataModel addObject: guestInformation];
    [self updateViewModel];
    
    [self.guestsTableView beginUpdates];
    [self.guestsTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.dataModel count] - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.guestsTableView endUpdates];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * cellViewModel = self.viewModel[indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: cellViewModel[@"nib"]];
    
    if([cell respondsToSelector:@selector(setData:)]) {
        [cell performSelector:@selector(setData:) withObject:cellViewModel[@"data"]];
    }
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 365, .5)];/// change size as you need.
    separatorLineView.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:separatorLineView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * cellViewModel = self.viewModel[indexPath.row];
    return [cellViewModel[@"height"] floatValue];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    NSDictionary * selectedGuest = self.viewModel[indexPath.row];
    [self performSegueWithIdentifier:@"editGuestDetails" sender: selectedGuest[@"data"]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary *)sender {
    EditGuestDetailViewController * editGuestDetailViewController = (EditGuestDetailViewController *)segue.destinationViewController;
    [editGuestDetailViewController setCurrentGuest: sender];
}

@end