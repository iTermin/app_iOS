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
#import "ArrayOfCountries.h"


@interface EditGuestDetailViewController ()
{
    BOOL changedInformation;
}

@end

@implementation EditGuestDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayCountries = [ArrayOfCountries new];
    self.modelCountries = [self.arrayCountries getModelCountries];
    
    self.guestInformation = [NSMutableDictionary dictionary];

    [self updateViewModel];
    
    self.guestPhoto.layer.cornerRadius = self.guestPhoto.frame.size.width/2.0f;
    self.guestPhoto.clipsToBounds = YES;
    
    self.nameGuest.delegate = self;
    self.emailGuest.delegate = self;
    
    UITapGestureRecognizer * tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];    
    [self.guestPhoto addGestureRecognizer:tapImage];
    
}

-(void) customCell {
    [self.nameGuest setText: self.guestInformation[@"name"]];
    [self.emailGuest setText: self.guestInformation[@"email"]];
    
    [self setImage];
}

- (void) setImage{
    if ([self.guestInformation[@"photo"] isKindOfClass:[NSString class]]){
        if ([self.guestInformation[@"photo"] isEqualToString:@""]) {
            NSString *userName = self.guestInformation[@"name"];
            [self.guestPhoto setImageWithString:userName color:nil circular:YES];
        } else {
            self.guestPhoto.layer.cornerRadius = self.guestPhoto.frame.size.width/2.0f;
            self.guestPhoto.clipsToBounds = YES;
            NSString *getPhoto = [NSString stringWithFormat:@"%@.png", self.guestInformation[@"photo"]];
            [self.guestPhoto setImage:[UIImage imageNamed:getPhoto]];
        }
    } else {
        [self.guestPhoto setImage:self.guestInformation[@"photo"]];
    }
}

- (void) updateViewModel {
    if (changedInformation == NO) {
        self.guestInformation = [NSMutableDictionary dictionaryWithDictionary:self.currentGuest];
    }
    
    NSString *countryName = [self getNameCountry:self.guestInformation];
    [self.guestInformation setObject:countryName forKey:@"nameCountry"];
    
    if (changedInformation) [self.guestInformationDelegate guestInformation:self didChangedInformation:self.guestInformation];

    NSArray *viewModel = @[
                  @{
                      @"nib" : @"LocationGuestTableViewCell",
                      @"height" : @(60),
                      @"segue" : @"guestListCountries",
                      @"data": [self.guestInformation copy]
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
    NSString *nameCountry = [NSString new];
    
    NSArray * ListCountriesInformation = self.modelCountries;
    NSDictionary * countryInformaton = [NSDictionary dictionary];
    
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

- (void) changedTextName{
    NSString *nameGuest = self.nameGuest.text;
    if (![self.nameGuest.text isEqualToString:self.guestInformation[@"name"]]){
        changedInformation = YES;
        [self.guestInformation removeObjectForKey:@"name"];
        [self.guestInformation setObject:nameGuest forKey:@"name"];
        [self updateViewModel];
    }
}

- (void) changedTextEmail {
    NSString *emailGuest = self.emailGuest.text;
    if (![self.emailGuest.text isEqualToString:self.guestInformation[@"email"]]){
        BOOL emailIsValid = [self validateEmail:self.emailGuest.text];
        if (emailIsValid){
            changedInformation = YES;
            [self.guestInformation removeObjectForKey:@"email"];
            [self.guestInformation setObject:emailGuest forKey:@"email"];
            [self updateViewModel];
        }
        else{
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

- (BOOL) validateEmail:(NSString*) emailAddress{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self.emailGuest.text];
    //ref:http://stackoverflow.com/a/22344769/5757715
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
    
    self.guestInformation = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        currentGuestInformation[@"name"], @"name",
                        currentGuestInformation[@"codePhone"], @"codePhone",
                        currentGuestInformation[@"email"], @"email",
                        currentGuestInformation[@"photo"], @"photo",
                        newCountry[@"code"], @"codeCountry", nil];
    
    [self updateViewModel];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    changedInformation = YES;
    
    self.guestInformation[@"photo"] = [self imageWithImage:image scaledToSize:CGSizeMake(200, 200)];
    [self updateViewModel];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (UIImage*)imageWithImage:(UIImage *) image scaledToSize:(CGSize) newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
