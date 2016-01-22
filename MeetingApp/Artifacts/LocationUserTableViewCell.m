//
//  LocationUserTableViewCell.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/22/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "LocationUserTableViewCell.h"

@implementation LocationUserTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setData:(NSDictionary *)data {
    _data = data;
    
    [self.locationText setText: data[@"location"]];
    
}

@end
