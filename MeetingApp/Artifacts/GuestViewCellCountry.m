//
//  GuestViewCellCountry.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/6/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "GuestViewCellCountry.h"

@implementation GuestViewCellCountry

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
    
    self.guestImage.layer.cornerRadius = self.guestImage.frame.size.width/2.0f;
    self.guestImage.clipsToBounds = YES;
    NSString *identyPhoto = [NSString stringWithFormat:@"%@.png", data[@"codeCountry"]];
    [self.guestImage setImage:[UIImage imageNamed:identyPhoto]];
    
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

@end
