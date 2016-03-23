//
//  GeneralInformationUserTableViewCell.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/20/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "GeneralInformationUserTableViewCell.h"
#import "UIImageView+Letters.h"


@implementation GeneralInformationUserTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2.0f;
    self.profilePicture.clipsToBounds = YES;
    self.profilePicture.layer.borderWidth = 4.0f;
    self.profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void) setData:(NSDictionary *)data {
    _data = data;
    
    if ([_data[@"photo"] isKindOfClass:[NSString class]]){
        if ([_data[@"photo"] isEqualToString:@""]) {
            NSString *userName = _data[@"name"];
            [self.profilePicture setImageWithString:userName color:nil circular:YES];
        } else {
            self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2.0f;
            self.profilePicture.clipsToBounds = YES;
            NSString *getPhoto = [NSString stringWithFormat:@"%@.png", _data[@"photo"]];
            [self.profilePicture setImage:[UIImage imageNamed:getPhoto]];
        }
    } else {
        [self.profilePicture setImage:_data[@"photo"]];
    }
    
    [self.nameText setText: _data[@"name"]];
    [self.emailText setText: _data[@"email"]];
    [self.locationText setText: _data[@"country"]];
    
    NSString *identifyFlagPhoto = [NSString stringWithFormat:@"%@.png", _data[@"code"]];
    [self.countryphoto setImage:[UIImage imageNamed:identifyFlagPhoto]];
    
}

@end
