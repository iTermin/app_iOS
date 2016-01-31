//
//  EditGuestDetailViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/31/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditGuestDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *guestPhoto;
@property (strong, nonatomic) IBOutlet UITextField *nameGuest;
@property (strong, nonatomic) IBOutlet UITextField *emailGuest;
@property (strong, nonatomic) IBOutlet UITableView *locationGuest;

@property(nonatomic, strong) NSDictionary * currentGuest;

@property(strong) NSArray *viewModel;


@end
