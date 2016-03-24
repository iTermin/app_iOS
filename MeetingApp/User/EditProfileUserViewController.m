//
//  EditProfileUserViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/20/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "EditProfileUserViewController.h"
#import "ListCountriesViewController.h"
#import "UIImageView+Letters.h"


@interface EditProfileUserViewController ()
{
    BOOL changedInformation;
}

@end

@implementation EditProfileUserViewController

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoProfileEdit.layer.cornerRadius = self.photoProfileEdit.frame.size.width/2.0f;
    self.photoProfileEdit.clipsToBounds = YES;
    
    CALayer *nameBorder = [CALayer layer];
    nameBorder.frame = CGRectMake(0.0f, self.nameText.frame.size.height - 1, self.nameText.frame.size.width, 1.0f);
    nameBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.nameText.layer addSublayer:nameBorder];
    self.nameText.delegate = self;
    
    CALayer *emailBorder = [CALayer layer];
    emailBorder.frame = CGRectMake(0.0f, self.nameText.frame.size.height - 1, self.nameText.frame.size.width, 1.0f);
    emailBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.emailText.layer addSublayer:emailBorder];
    self.emailText.delegate = self;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.photoProfileEdit addGestureRecognizer:tapRecognizer];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self updateViewModel];
    
}

- (void) updateViewModel {
    if (changedInformation == NO)
        self.hostInformation = [NSMutableDictionary dictionaryWithDictionary:self.currentHost];
    
    if (changedInformation)
        [self.userInformationDelegate userInformation:self didChangedInformation:self.hostInformation];
    
    NSArray * viewModel = @[
                            @{
                                @"nib" : @"LocationUserTableViewCell",
                                @"height" : @(70),
                                @"segue" : @"selectCountry",
                                @"data": [self.hostInformation copy]
                                }
                            ];
    
    self.viewModel = [NSMutableArray arrayWithArray: viewModel];
    
    [self customCell];
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    [super updateViewModel];
}

-(void) customCell {
    [self.nameText setText: self.hostInformation[@"name"]];
    [self.emailText setText: self.hostInformation[@"email"]];
    
    [self setImage];
}

- (void) setImage{
    if ([self.hostInformation[@"photo"] isKindOfClass:[NSString class]]){
        if ([self.hostInformation[@"photo"] isEqualToString:@""]) {
            NSString *userName = self.hostInformation[@"name"];
            [self.photoProfileEdit setImageWithString:userName color:[UIColor colorWithRed:1 green:0.411 blue:0.411 alpha:1] circular:YES];
        } else {
            self.photoProfileEdit.layer.cornerRadius = self.photoProfileEdit.frame.size.width/2.0f;
            self.photoProfileEdit.clipsToBounds = YES;

            [self.photoProfileEdit setImage:[UIImage imageWithData:
                                             [self decodeBase64ToImage:self.hostInformation[@"photo"]]]];
        }
    } else {
        [self.photoProfileEdit setImage:self.hostInformation[@"photo"]];
    }
}

- (NSData *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

- (void) performSegue: (NSIndexPath *)indexPath{
    NSString *country = self.hostInformation[@"country"];
    NSDictionary * cellModel = self.viewModel[indexPath.row];
    NSString * segueToPerform = cellModel[@"segue"];
    [self performSegueWithIdentifier:segueToPerform sender:country];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary *)sender {
    if ([segue.identifier isEqualToString:@"selectCountry"]){
        ListCountriesViewController * locationViewController = (ListCountriesViewController *)segue.destinationViewController;
        [locationViewController setCurrentLocation:sender];
        [locationViewController setCountrySelectorDelegate:self];
    }
}

- (void) countrySelector: (UIViewController<ICountrySelector> *) countrySelector
        didSelectCountry: (NSDictionary *) country{
    [self changedCountryUpdateUserInformation: country];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) changedCountryUpdateUserInformation: (NSDictionary *) newCountry{
    NSDictionary *currentUserInformation = [NSDictionary dictionaryWithDictionary:self.hostInformation];
    
    changedInformation = YES;
    
    [self.hostInformation removeAllObjects];
    self.hostInformation = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                             currentUserInformation[@"name"], @"name",
                             currentUserInformation[@"email"], @"email",
                             currentUserInformation[@"photo"], @"photo",
                             newCountry[@"name"], @"country",
                             newCountry[@"code"], @"code", nil];
    
    [self updateViewModel];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.navigationBar.tintColor = [UIColor blueColor];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //Or you can get the image url from AssetsLibrary
    //NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    changedInformation = YES;

    image = [self imageWithImage:image scaledToSize:CGSizeMake(100, 100)];
    self.hostInformation[@"photo"] = [self encodeToBase64String:image];
    
    [self updateViewModel];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image)
            base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage*)imageWithImage:(UIImage *) image scaledToSize:(CGSize) newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameText)
        [self changedTextName];
    if (textField == self.emailText)
        [self changedTextEmail];
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void) changedTextName{
    NSString *nameGuest = self.nameText.text;
    if (![self.nameText.text isEqualToString:self.hostInformation[@"name"]]){
        changedInformation = YES;
        [self.hostInformation removeObjectForKey:@"name"];
        [self.hostInformation setObject:nameGuest forKey:@"name"];
        [self updateViewModel];
    }
}

- (void) changedTextEmail {
    NSString *emailGuest = self.emailText.text;
    if (![self.emailText.text isEqualToString:self.hostInformation[@"email"]]){
        BOOL emailIsValid = [self validateEmail:self.emailText.text];
        if (emailIsValid){
            changedInformation = YES;
            [self.hostInformation removeObjectForKey:@"email"];
            [self.hostInformation setObject:emailGuest forKey:@"email"];
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
    return [emailTest evaluateWithObject:self.emailText.text];
    //ref:http://stackoverflow.com/a/22344769/5757715
}


@end
