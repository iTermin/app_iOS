//
//  EditProfileUserViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/20/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileUserViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoProfileEdit;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITableView *locationTableView;

@property(strong) NSDictionary *dataModel;

@property(strong) NSArray *viewModel;

@property(nonatomic, strong) NSDictionary * currentLocation;

@end
