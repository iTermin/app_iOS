//
//  MeetingTableViewCell.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/6/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "MeetingTableViewCell.h"
#import "UIImageView+Letters.h"

@implementation MeetingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setData:(NSDictionary *)data {
    _data = data;
    
    [self.nameMeeting setText: _data[@"name"]];
    [self.dateMeeting setText: _data[@"date"]];
    
    NSString *nameMeeting = data[@"name"];
    [self.imageMeeting setImageWithString:nameMeeting color:nil circular:YES];
    
}

@end
