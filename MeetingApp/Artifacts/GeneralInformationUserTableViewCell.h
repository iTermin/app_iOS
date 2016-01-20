//
//  GeneralInformationUserTableViewCell.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/20/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeneralInformationUserTableViewCell : UITableViewCell

@property(nonatomic, weak) NSDictionary * data;

@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UILabel *emailText;

@end
