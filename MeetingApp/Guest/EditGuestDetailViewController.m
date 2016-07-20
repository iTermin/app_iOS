//
//  EditGuestDetailViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/31/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>

#import "EditGuestDetailViewController.h"
#import "UIImageView+Letters.h"
#import "ArrayOfCountries.h"
#import "MBProgressHUD.h"


@interface EditGuestDetailViewController ()
{
    BOOL changedInformation;
}

@end

@implementation EditGuestDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self updateViewModel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayCountries = [ArrayOfCountries new];
    self.modelCountries = [self.arrayCountries getModelCountries];
    
    self.guestInformation = [NSMutableDictionary dictionary];
    
    [self layoutUITextFields];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = NO;
    
    UITapGestureRecognizer * tapImage = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(tapAction:)];
    [self.guestPhoto addGestureRecognizer:tapImage];
}

- (void) layoutUITextFields{
    
    CALayer *nameBorder = [CALayer layer];
    nameBorder.frame = CGRectMake(0.0f,
                                  self.nameGuest.frame.size.height - 1,
                                  self.nameGuest.frame.size.width,
                                  1.0f);
    nameBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.nameGuest.layer addSublayer:nameBorder];
    self.nameGuest.delegate = self;
    [self.nameGuest setReturnKeyType:UIReturnKeyDone];
    
    CALayer *emailBorder = [CALayer layer];
    emailBorder.frame = CGRectMake(0.0f,
                                   self.emailGuest.frame.size.height - 1,
                                   self.emailGuest.frame.size.width,
                                   1.0f);
    emailBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.emailGuest.layer addSublayer:emailBorder];
    self.emailGuest.delegate = self;
    [self.emailGuest setReturnKeyType:UIReturnKeyDone];
    
    [self layoutsLocationGuest];
}

- (void) layoutsLocationGuest{
    CALayer *locationBorder = [CALayer layer];
    locationBorder.frame = CGRectMake(0.0f,
                                      self.locationGuest.frame.size.height - 1,
                                      self.locationGuest.frame.size.width,
                                      1.0f);
    locationBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.locationGuest.layer addSublayer:locationBorder];
    self.locationGuest.delegate = self;
    [self.locationGuest setReturnKeyType:UIReturnKeyDone];
    
    self.locationGuest.placeSearchDelegate = self;
    self.locationGuest.strApiKey = @"AIzaSyCDi2dklT-95tEHqYoE7Tklwzn3eJP-MtM";
    self.locationGuest.superViewOfList = self.view;
    self.locationGuest.autoCompleteShouldHideOnSelection = YES;
    self.locationGuest.maximumNumberOfAutoCompleteRows = 4;
}

- (void)viewDidAppear:(BOOL)animated{    
    self.locationGuest.autoCompleteRegularFontName =  @"Optima";
    self.locationGuest.autoCompleteBoldFontName = @"Optima-Bold";
    self.locationGuest.autoCompleteTableCornerRadius=0.0;
    self.locationGuest.autoCompleteRowHeight=35;
    self.locationGuest.autoCompleteTableCellTextColor=[UIColor colorWithWhite:0.131 alpha:1.000];
    self.locationGuest.autoCompleteFontSize=14;
    self.locationGuest.autoCompleteTableBorderWidth=1.0;
    self.locationGuest.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=NO;
    self.locationGuest.autoCompleteShouldHideOnSelection=YES;
    self.locationGuest.autoCompleteShouldHideClosingKeyboard=YES;
    self.locationGuest.autoCompleteShouldSelectOnExactMatchAutomatically = YES;
    self.locationGuest.autoCompleteTableFrame = CGRectMake(self.locationGuest.frame.origin.x, (self.locationGuest.frame.origin.y+self.locationGuest.frame.size.height), self.locationGuest.frame.size.width, 200.0);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y -200.,
                                 self.view.frame.size.width,
                                 self.view.frame.size.height);
    
        [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y +200.,
                                 self.view.frame.size.width,
                                 self.view.frame.size.height);
    
    [UIView commitAnimations];
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
            
            [self.guestPhoto setImage:circularImageWithImage
             ([UIImage imageWithData: [self decodeBase64ToImage:self.guestInformation[@"photo"]]])];

        }
    } else {
        [self.guestPhoto setImage:self.guestInformation[@"photo"]];
    }
}

static UIImage *circularImageWithImage(UIImage *inputImage)
{
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 20, 220, 220)];
    
    // Create an image context containing the original UIImage.
    UIGraphicsBeginImageContext(inputImage.size);
    
    // Clip to the bezier path and clear that portion of the image.
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context,bezierPath.CGPath);
    CGContextClip(context);
    
    // Draw here when the context is clipped
    [inputImage drawAtPoint:CGPointZero];
    
    // Build a new UIImage from the image context.
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (NSData *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
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
                      @"height" : @(70),
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

//- (void) countrySelector: (UIViewController<ICountrySelector> *) countrySelector
//        didSelectCountry: (NSDictionary *) country
//{
//    [self changedCountryUpdateGuestInformation: country];
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void) changedCountryUpdateGuestInformation: (NSDictionary *) newCountry{
    changedInformation = YES;
    
    [self.guestInformation removeObjectForKey:@"codeCountry"];
    [self.guestInformation removeObjectForKey:@"nameCountry"];
    [self.guestInformation setObject:newCountry[@"code"] forKey:@"codeCountry"];
    
    [self updateViewModel];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    hud.color = [UIColor lightGrayColor];
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.navigationBar.tintColor = [UIColor blueColor];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    changedInformation = YES;
    
    image = [self imageWithImage:image scaledToSize:CGSizeMake(220, 260)];
    self.guestInformation[@"photo"] = [self encodeToBase64String:image];
    
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

- (void) placeSearchResponseForSelectedPlace:(NSMutableDictionary *)responseDict{
    NSDictionary* locationPlaceSearch =[[[responseDict objectForKey:@"result"] objectForKey:@"geometry"] objectForKey:@"location"];
    
    NSString* addressPlaceSearch=[[responseDict objectForKey:@"result"] objectForKey:@"formatted_address"];
    
    double latitude = [[locationPlaceSearch valueForKey:@"lat"] doubleValue];
    double longitude = [[locationPlaceSearch valueForKey:@"lng"] doubleValue];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude
                                                      longitude:longitude];
    
    CLGeocoder * reference = [CLGeocoder new];
    
    [reference reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * placemarks, NSError * error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        NSDictionary * locationGuest = @{
                                        @"placeSelected": [NSString stringWithString:addressPlaceSearch],
                                        @"timezone": [NSString stringWithString:placemark.timeZone.abbreviation],
                                        @"nameTimezone": [NSString stringWithString:placemark.timeZone.name],
                                        @"country": [NSString stringWithString:placemark.country],
                                        @"isoCountry" : [NSString stringWithString:placemark.ISOcountryCode]
                                        };
        //[self changedLocationUser: locationUser];
        [self.view endEditing:YES];
    }];
}

- (void) placeSearchWillShowResult{
}

-(void) placeSearchWillHideResult{
}

- (void) placeSearchResultCell:(UITableViewCell *)cell withPlaceObject:(PlaceObject *)placeObject atIndex:(NSInteger)index{
    if(index%2==0){
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
}

@end
