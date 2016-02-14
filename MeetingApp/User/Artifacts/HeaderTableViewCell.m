//
//  HeaderTableViewCell.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/19/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "HeaderTableViewCell.h"

@implementation HeaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setData:(NSDictionary *)data {
    _data = data;
    
    [self.headerText setText: data[@"text"]];
}

@end
