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
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss ZZZZ"];
    NSDate *date = [dateFormatter dateFromString:_data[@"date"]];
    [dateFormatter setDateFormat:@"dd MMMM yyyy   HH:mm:ss"];

    [self.dateMeeting setText:[dateFormatter stringFromDate:date]];
    
    NSString *nameMeeting = data[@"name"];
    [self.imageMeeting setImageWithString:nameMeeting color:[UIColor colorWithRed:0.992 green:0.694 blue:.294 alpha:1] circular:YES];
    
}

@end
