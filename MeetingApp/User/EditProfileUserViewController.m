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


@end

@implementation EditProfileUserViewController

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.nameText setText: self.dataModel[@"name"]];
    [self.emailText setText: self.dataModel[@"email"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.photoProfileEdit.layer.cornerRadius = self.photoProfileEdit.frame.size.width/2.0f;
    self.photoProfileEdit.clipsToBounds = YES;
    //self.photoProfileEdit.layer.borderWidth = 4.0f;
    //self.photoProfileEdit.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.photoEditButton.layer.cornerRadius = self.photoEditButton.frame.size.width/5.0f;
    self.photoEditButton.clipsToBounds = YES;
    
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
    
    NSArray * viewModel = @[
                            @{
                                @"nib" : @"LocationUserTableViewCell",
                                @"height" : @(80),
                                @"segue" : @"selectCountry",
                                @"data": [self.dataModel copy]
                                }
                            ];
    
    self.viewModel = [NSMutableArray arrayWithArray: viewModel];
    
    [super updateViewModel];
}

- (void) performSegue: (NSIndexPath *)indexPath{
    NSString *country = self.dataModel[@"location"];
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
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    UIImage *image = [UIImage imageNamed:@"inicio"];
}

- (IBAction)editPhotoUser:(id)sender {

    
}
@end
