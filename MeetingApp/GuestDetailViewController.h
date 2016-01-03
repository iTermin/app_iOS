//
//  GuestDetailViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 12/31/15.
//  Copyright © 2015 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuestDetailViewController : UIViewController

@property(nonatomic, strong) NSDictionary * currentGuest;
@property (weak, nonatomic) IBOutlet UILabel *nameOfGuest;
@property (weak, nonatomic) IBOutlet UILabel *emailOfGuest;

@end