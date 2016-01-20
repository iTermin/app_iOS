//
//  ProfilePhotoTableViewCell.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/19/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "ProfilePhotoTableViewCell.h"

@implementation ProfilePhotoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    //self.profilePicture.frame = CGRectMake(0, 0, 60, 40);
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2.0f;
    self.profilePicture.clipsToBounds = YES;
    self.profilePicture.layer.borderWidth = 4.0f;
    self.profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
}

@end
