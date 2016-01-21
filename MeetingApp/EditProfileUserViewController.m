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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.photoProfileEdit.layer.cornerRadius = self.photoProfileEdit.frame.size.width/2.0f;
    self.photoProfileEdit.clipsToBounds = YES;
    self.photoProfileEdit.layer.borderWidth = 4.0f;
    self.photoProfileEdit.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:nil];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
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
