//
//  EditProfileUserViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/20/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "EditProfileUserViewController.h"

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
    self.photoProfileEdit.layer.borderWidth = 4.0f;
    self.photoProfileEdit.layer.borderColor = [UIColor whiteColor].CGColor;
    
    CALayer *nameBorder = [CALayer layer];
    nameBorder.frame = CGRectMake(0.0f, self.nameText.frame.size.height - 1, self.nameText.frame.size.width, 1.0f);
    nameBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.nameText.layer addSublayer:nameBorder];
    
    CALayer *emailBorder = [CALayer layer];
    emailBorder.frame = CGRectMake(0.0f, self.nameText.frame.size.height - 1, self.nameText.frame.size.width, 1.0f);
    emailBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.emailText.layer addSublayer:emailBorder];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
