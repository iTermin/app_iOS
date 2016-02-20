//
//  GuestDateViewCell.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/15/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuestDateViewCell : UITableViewCell

@property(nonatomic, weak) NSDictionary * data;

@property (strong, nonatomic) IBOutlet UIImageView *photoGuest;
@property (strong, nonatomic) IBOutlet UIImageView *dateIndicatorGuest;
@property (strong, nonatomic) IBOutlet UILabel *nameGuest;
@property (strong, nonatomic) IBOutlet UILabel *emailGuest;

@end
