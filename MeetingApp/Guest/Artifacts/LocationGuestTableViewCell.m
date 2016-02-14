//
//  LocationGuestTableViewCell.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/5/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "LocationGuestTableViewCell.h"

@implementation LocationGuestTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setData:(NSDictionary *)data {
    _data = data;
    
    [self.locationText setText: _data[@"nameCountry"]];
    
    NSString *identifyFlagPhoto = [NSString stringWithFormat:@"%@.png", _data[@"codeCountry"]];
    [self.locationPhoto setImage:[UIImage imageNamed:identifyFlagPhoto]];
}

@end
