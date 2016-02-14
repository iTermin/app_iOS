//
//  CountryViewCell.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/24/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "CountryViewCell.h"

@implementation CountryViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (self.isSelected)
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        self.accessoryType = UITableViewCellAccessoryNone;
}

- (void) setData:(NSDictionary *)data {
    _data = data;
    
    [self.nameCountry setText: data[@"name"]];
    [self.photoCountry setImage:data[@"flagIcon"]];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
