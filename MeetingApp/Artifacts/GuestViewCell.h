//
//  GuestViewCell.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/29/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuestViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameGuest;
@property (strong, nonatomic) IBOutlet UILabel *emailGuest;
@property (strong, nonatomic) IBOutlet UIImageView *guestImage;
@property (strong, nonatomic) IBOutlet UIImageView *disclosureImage;

@property(nonatomic, weak) NSDictionary * data;
@property(nonatomic, weak) NSString * code;

@end
