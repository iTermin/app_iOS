//
//  EditProfileUserViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/20/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "EditProfileUserViewController.h"
#import "UIImageView+Letters.h"
#import "MBProgressHUD.h"


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
    
    [self layoutTextFieldsView];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.photoProfileEdit addGestureRecognizer:tapRecognizer];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = NO;
    
    [self updateViewModel];
    
}

- (void) viewDidAppear:(BOOL)animated{
    self.locationTextField.autoCompleteRegularFontName =  @"Optima";
    self.locationTextField.autoCompleteBoldFontName = @"Optima-Bold";
    self.locationTextField.autoCompleteTableCornerRadius=0.0;
    self.locationTextField.autoCompleteRowHeight=35;
    self.locationTextField.autoCompleteTableCellTextColor=[UIColor colorWithWhite:0.131 alpha:1.000];
    self.locationTextField.autoCompleteFontSize=14;
    self.locationTextField.autoCompleteTableBorderWidth=1.0;
    self.locationTextField.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=NO;
    self.locationTextField.autoCompleteShouldHideOnSelection=YES;
    self.locationTextField.autoCompleteShouldHideClosingKeyboard=YES;
    self.locationTextField.autoCompleteShouldSelectOnExactMatchAutomatically = YES;
    self.locationTextField.autoCompleteTableFrame = CGRectMake(self.locationTextField.frame.origin.x, (self.locationTextField.frame.origin.y+self.locationTextField.frame.size.height), self.locationTextField.frame.size.width, 200.0);
}

- (void) layoutTextFieldsView{
    CALayer *nameBorder = [CALayer layer];
    nameBorder.frame = CGRectMake(0.0f, self.nameText.frame.size.height - 1, self.nameText.frame.size.width, 1.0f);
    nameBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.nameText.layer addSublayer:nameBorder];
    self.nameText.delegate = self;
    [self.nameText setReturnKeyType:UIReturnKeyDone];
    
    CALayer *emailBorder = [CALayer layer];
    emailBorder.frame = CGRectMake(0.0f, self.emailText.frame.size.height - 1, self.emailText.frame.size.width, 1.0f);
    emailBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.emailText.layer addSublayer:emailBorder];
    self.emailText.delegate = self;
    [self.emailText setReturnKeyType:UIReturnKeyDone];
    
    [self specificLayoutLocationTextField];
}

- (void) specificLayoutLocationTextField{
    CALayer *locationBorder = [CALayer layer];
    locationBorder.frame = CGRectMake(0.0f, self.locationTextField.frame.size.height - 1, self.locationTextField.frame.size.width, 1.0f);
    locationBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.locationTextField.layer addSublayer:locationBorder];
    self.locationTextField.delegate = self;
    [self.locationTextField setReturnKeyType:UIReturnKeyDone];
    
    self.locationTextField.placeSearchDelegate = self;
    self.locationTextField.strApiKey = @"AIzaSyCDi2dklT-95tEHqYoE7Tklwzn3eJP-MtM";
    self.locationTextField.superViewOfList = self.view;
    self.locationTextField.autoCompleteShouldHideOnSelection = YES;
    self.locationTextField.maximumNumberOfAutoCompleteRows = 4;
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

            [self.photoProfileEdit setImage:circularImageWithImage
             ([UIImage imageWithData: [self decodeBase64ToImage:self.hostInformation[@"photo"]]])];
        }
    } else {
        [self.photoProfileEdit setImage:self.hostInformation[@"photo"]];
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

- (void) changedCountryUpdateUserInformation: (NSDictionary *) newCountry{
    NSDictionary *currentUserInformation = [NSDictionary dictionaryWithDictionary:self.hostInformation];
    
    changedInformation = YES;
    
    [self.hostInformation removeAllObjects];
    self.hostInformation = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            currentUserInformation[@"name"], @"name",
                            currentUserInformation[@"email"], @"email",
                            currentUserInformation[@"photo"], @"photo",
                            newCountry[@"country"], @"country",
                            newCountry[@"isoCountry"], @"code",
                            newCountry[@"placeSelected"], @"place",
                            newCountry[@"timezone"], @"timezone",
                            newCountry[@"nameTimezone"], @"nameTimezone", nil];
    
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

- (UIImage *)imageWithImage:(UIImage *)sourceImage size:(CGSize)size {
    CGSize newSize = CGSizeZero;
    if ((sourceImage.size.width / size.width) < (sourceImage.size.height / size.height)) {
        newSize = CGSizeMake(sourceImage.size.width, size.height * (sourceImage.size.width / size.width));
    } else {
        newSize = CGSizeMake(size.width * (sourceImage.size.height / size.height), sourceImage.size.height);
    }
    
    CGRect cropRect = CGRectZero;
    cropRect.origin.x = (sourceImage.size.width - newSize.width) / 2.0f;
    cropRect.origin.y = (sourceImage.size.height - newSize.height) / 2.0f;
    cropRect.size = newSize;
    
    CGImageRef croppedImageRef = CGImageCreateWithImageInRect([sourceImage CGImage], cropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:croppedImageRef];
    CGImageRelease(croppedImageRef);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, 0.0);
    [croppedImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //Or you can get the image url from AssetsLibrary
    //NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    changedInformation = YES;
    image = [self imageWithImage:image scaledToSize:CGSizeMake(220, 260)];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y -200., self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y +200., self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameText){
        [self changedTextName];
    } else if (textField == self.emailText){
        [self changedTextEmail];
    }
    
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


- (void) changedLocationUser: (NSDictionary *) locationInfo {
    if (![locationInfo[@"country"] isEqualToString:self.hostInformation[@"country"]]) {
        [self changedCountryUpdateUserInformation: locationInfo];
    }
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
        NSDictionary * locationUser = @{
                                        @"placeSelected": [NSString stringWithString:addressPlaceSearch],
                                        @"timezone": [NSString stringWithString:placemark.timeZone.abbreviation],
                                        @"nameTimezone": [NSString stringWithString:placemark.timeZone.name],
                                        @"country": [NSString stringWithString:placemark.country],
                                        @"isoCountry" : [NSString stringWithString:placemark.ISOcountryCode]
                                        };
        [self changedLocationUser: locationUser];
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
