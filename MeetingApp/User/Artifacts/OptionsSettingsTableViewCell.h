//
//  OptionsSettingsTableViewCell.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/20/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsSettingsTableViewCell : UITableViewCell

@property(nonatomic, weak) NSDictionary * data;

@property (weak, nonatomic) IBOutlet UILabel *optionSetting;

@property (weak, nonatomic) IBOutlet UIImageView *disclosureImage;

@end
