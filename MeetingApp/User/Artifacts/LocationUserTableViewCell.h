//
//  LocationUserTableViewCell.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/22/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationUserTableViewCell : UITableViewCell

@property(nonatomic, weak) NSDictionary * data;

@property (strong, nonatomic) IBOutlet UILabel *locationText;
@property (strong, nonatomic) IBOutlet UIImageView *locationPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *disclosureImage;

@end
