//
//  EditProfileUserViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/20/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "EditProfileUserViewController.h"
#import "ListCountriesViewController.h"

@interface EditProfileUserViewController ()
{
    BOOL changedInformation;
}

@end

@implementation EditProfileUserViewController

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.nameText setText: self.hostInformation[@"name"]];
    [self.emailText setText: self.hostInformation[@"email"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.arrayCountries = [ArrayOfCountries new];
    self.modelCountries = [self.arrayCountries getModelCountries];
    
    self.photoProfileEdit.layer.cornerRadius = self.photoProfileEdit.frame.size.width/2.0f;
    self.photoProfileEdit.clipsToBounds = YES;
    
    CALayer *nameBorder = [CALayer layer];
    nameBorder.frame = CGRectMake(0.0f, self.nameText.frame.size.height - 1, self.nameText.frame.size.width, 1.0f);
    nameBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.nameText.layer addSublayer:nameBorder];
    
    CALayer *emailBorder = [CALayer layer];
    emailBorder.frame = CGRectMake(0.0f, self.nameText.frame.size.height - 1, self.nameText.frame.size.width, 1.0f);
    emailBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.emailText.layer addSublayer:emailBorder];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.photoProfileEdit addGestureRecognizer:tapRecognizer];
    
    [self updateViewModel];
    
}

- (void) updateViewModel {
    if (changedInformation == NO){
        self.hostInformation = [NSMutableDictionary dictionaryWithDictionary:self.currentHost];
        NSString *countryName = [self getNameCountry:self.hostInformation];
        [self.hostInformation setObject:countryName forKey:@"country"];
    }
    
    if (changedInformation) [self.userInformationDelegate userInformation:self didChangedInformation:self.hostInformation];
    
    NSArray * viewModel = @[
                            @{
                                @"nib" : @"LocationUserTableViewCell",
                                @"height" : @(80),
                                @"segue" : @"selectCountry",
                                @"data": [self.hostInformation copy]
                                }
                            ];
    
    self.viewModel = [NSMutableArray arrayWithArray: viewModel];
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    [super updateViewModel];
}

- (NSString*) getNameCountry: (NSDictionary *)dataInformation{
    NSString *codeCountry = dataInformation[@"code"];
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

- (void) performSegue: (NSIndexPath *)indexPath{
    NSString *country = self.hostInformation[@"country"];
    NSDictionary * cellModel = self.viewModel[indexPath.row];
    NSString * segueToPerform = cellModel[@"segue"];
    [self performSegueWithIdentifier:segueToPerform sender:country];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
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
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //Or you can get the image url from AssetsLibrary
    //NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    changedInformation = YES;
    
    [self.photoProfileEdit setImage:image];
    //[self updateViewModel];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


@end
