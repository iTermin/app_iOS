//
//  EditGuestDetailViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/31/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "EditGuestDetailViewController.h"
#import "UIImageView+Letters.h"
#import "GuestListCountriesTableViewController.h"

@interface EditGuestDetailViewController ()
{
    NSMutableDictionary *guestInformation;
    BOOL changedInformation;
}

@end

@implementation EditGuestDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataModel = @{
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
    [self updateViewModel];
    
    self.nameGuest.delegate = self;
    self.emailGuest.delegate = self;
    [self.navigationController setToolbarHidden:YES animated:YES];
}

-(void) customCell {
    [self.nameGuest setText: guestInformation[@"name"]];
    [self.emailGuest setText: guestInformation[@"email"]];
    
    NSString *noPhoto = @"";
    if (guestInformation[@"photo"] == noPhoto) {
        NSString *userName = guestInformation[@"name"];
        [self.guestPhoto setImageWithString:userName color:nil circular:YES];
    } else {
        self.guestPhoto.layer.cornerRadius = self.guestPhoto.frame.size.width/2.0f;
        self.guestPhoto.clipsToBounds = YES;
        NSString *getPhoto = [NSString stringWithFormat:@"%@.png", guestInformation[@"photo"]];
        [self.guestPhoto setImage:[UIImage imageNamed:getPhoto]];
    }
}

- (void) updateViewModel {
    if (changedInformation == NO) {
        guestInformation = self.currentGuest;
    }
    
    NSString *countryName = [self getNameCountry:guestInformation];
    [guestInformation setObject:countryName forKey:@"nameCountry"];
    
    if (changedInformation) [self.guestInformationDelegate guestInformation:self didChangedInformation:guestInformation];

    NSArray *viewModel = @[
                  @{
                      @"nib" : @"LocationGuestTableViewCell",
                      @"height" : @(60),
                      @"segue" : @"guestListCountries",
                      @"data": [guestInformation copy]
                      }
                  ];
    
    self.viewModel = [NSMutableArray arrayWithArray: viewModel];
    
    [self customCell];
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    [super updateViewModel];
}

- (NSString*) getNameCountry: (NSDictionary *)dataInformation{
    NSString *codeCountry = dataInformation[@"codeCountry"];
    NSString *nameCountry = @"";
    
    NSDictionary * ListCountriesInformation = self.dataModel[@"countries"];
    NSDictionary * countryInformaton;
    
    for (countryInformaton in ListCountriesInformation) {
        NSString * code = countryInformaton[@"code"];
        if ([code isEqualToString: codeCountry]) {
            return nameCountry = countryInformaton[@"name"];
        }
    }
    return nameCountry;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameGuest)
        [self changedTextName];
    if (textField == self.emailGuest)
        [self changedTextEmail];
    
    [textField resignFirstResponder];

    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
    
    [self changedTextName];
    [self changedTextEmail];
}

- (void) changedTextName{
    NSString *nameGuest = self.nameGuest.text;
    if (![self.nameGuest.text isEqualToString:guestInformation[@"name"]]){
        changedInformation = YES;
        [guestInformation removeObjectForKey:@"name"];
        [guestInformation setObject:nameGuest forKey:@"name"];
        [self updateViewModel];
    }
}

- (void) changedTextEmail {
    NSString *emailGuest = self.emailGuest.text;
    if (![self.emailGuest.text isEqualToString:guestInformation[@"email"]])
        guestInformation[@"email"] = emailGuest;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary *)sender {
    if ([segue.identifier isEqualToString:@"guestListCountries"]){
        GuestListCountriesTableViewController * guestListCountries = (GuestListCountriesTableViewController *)segue.destinationViewController;
        [guestListCountries setCurrentGuest: sender];
        [guestListCountries setCountrySelectorDelegate:self];
    }
}

- (void) countrySelector: (UIViewController<ICountrySelector> *) countrySelector
        didSelectCountry: (NSDictionary *) country
{
    [self changedCountryUpdateGuestInformation: country];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) changedCountryUpdateGuestInformation: (NSDictionary *) newCountry{
    NSDictionary *currentGuestInformation = self.currentGuest;

    changedInformation = YES;
    
    guestInformation = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        currentGuestInformation[@"name"], @"name",
                        currentGuestInformation[@"codePhone"], @"codePhone",
                        currentGuestInformation[@"email"], @"email",
                        currentGuestInformation[@"photo"], @"photo",
                        newCountry[@"code"], @"codeCountry", nil];
    
    [self updateViewModel];
}

@end
