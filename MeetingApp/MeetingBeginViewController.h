//
//  MeetingBeginViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 12/28/15.
//  Copyright © 2015 Estefania Chavez Guardado. All rights reserved.
//
/* MeetingBeginViewController_h */

#import <UIKit/UIKit.h>

@interface MeetingBeginViewController : UIViewController

@property(nonatomic, weak) IBOutlet UIButton * cancelButton;
@property(nonatomic, weak) IBOutlet UIButton * nextButton;

- (IBAction)cancelButtonPressed:(id)sender;

@end