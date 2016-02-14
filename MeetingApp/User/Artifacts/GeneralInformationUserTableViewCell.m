//
//  GeneralInformationUserTableViewCell.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/20/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "GeneralInformationUserTableViewCell.h"

@implementation GeneralInformationUserTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setData:(NSDictionary *)data {
    _data = data;
    
    [self.nameText setText: data[@"name"]];
    [self.emailText setText: data[@"email"]];
    [self.locationText setText: data[@"location"]];
    
}

@end
