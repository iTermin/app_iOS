//
//  GuestViewCell.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/29/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "GuestViewCell.h"
#import "UIImageView+Letters.h"

@implementation GuestViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setData:(NSDictionary *)data {
    _data = data;
    
    [self.nameGuest setText: data[@"name"]];
    [self.emailGuest setText: data[@"email"]];
    /*
    NSString *noPhoto = @"";
    if (data[@"photo"] == noPhoto) {
        NSString *userName = self.data[@"name"];
        [self.guestImage setImageWithString:userName color:nil circular:YES];
    } else {
        self.guestImage.layer.cornerRadius = self.guestImage.frame.size.width/2.0f;
        self.guestImage.clipsToBounds = YES;
        NSString *identyPhoto = [NSString stringWithFormat:@"%@.png", _data[@"photo"]];
        [self.guestImage setImage:[UIImage imageNamed:identyPhoto]];
    }
     */

}

- (void) setFlag:(NSString *)code {
    
    self.guestImage.layer.cornerRadius = self.guestImage.frame.size.width/2.0f;
    self.guestImage.clipsToBounds = YES;
    NSString *identyPhoto = [NSString stringWithFormat:@"%@.png", code];
    [self.guestImage setImage:[UIImage imageNamed:identyPhoto]];
    
    
}

@end
