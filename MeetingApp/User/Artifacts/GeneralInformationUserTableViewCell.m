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

- (void) setData:(NSDictionary *)data {
    _data = data;
    
    if ([_data[@"photo"] isKindOfClass:[NSString class]]){
        if ([_data[@"photo"] isEqualToString:@""]) {
            NSString *userName = _data[@"name"];
            [self.profilePicture setImageWithString:userName color:nil circular:YES];
        } else {
            self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2.0f;
            self.profilePicture.clipsToBounds = YES;
            [self.profilePicture setImage:circularImageWithImage
                ([UIImage imageWithData: [self decodeBase64ToImage:_data[@"photo"]]])];
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

- (NSData *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

static UIImage *circularImageWithImage(UIImage *inputImage)
{
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 20, 220, 220)];
    
    // Create an image context containing the original UIImage.
    UIGraphicsBeginImageContext(inputImage.size);
    
    // Clip to the bezier path and clear that portion of the image.
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context,bezierPath.CGPath);
    CGContextClip(context);
    
    // Draw here when the context is clipped
    [inputImage drawAtPoint:CGPointZero];
    
    // Build a new UIImage from the image context.
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
