//
//  GuestDateViewCell.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/15/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "GuestDateViewCell.h"
#import "UIImageView+Letters.h"

@implementation GuestDateViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setData:(NSDictionary *)data {
    _data = data;
    
    [self.nameGuest setText: _data[@"name"]];
    [self.emailGuest setText: _data[@"email"]];
    
    if ([data[@"photo"] isKindOfClass:[NSString class]]){
        if ([data[@"photo"] isEqualToString:@""]) {
            NSString *nameGuest = data[@"name"];
            [self.photoGuest setImageWithString:nameGuest color:nil circular:YES];
        } else{
            self.photoGuest.layer.cornerRadius = self.photoGuest.frame.size.width/2.0f;
            self.photoGuest.clipsToBounds = YES;
            NSString *identyPhoto = [NSString stringWithFormat:@"%@.png", data[@"photo"]];
            [self.photoGuest setImage:[UIImage imageNamed:identyPhoto]];
        }
    } else {
        self.photoGuest.layer.cornerRadius = self.photoGuest.frame.size.width/2.0f;
        self.photoGuest.clipsToBounds = YES;
        [self.photoGuest setImage:data[@"photo"]];
    }
    
    
    NSString *identyPhoto = [NSString stringWithFormat:@"%@.png", @"moon"];
    [self.dateIndicatorGuest setImage:[UIImage imageNamed:identyPhoto]];

    
    
}

@end
