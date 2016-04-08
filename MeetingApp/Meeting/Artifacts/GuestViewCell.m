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
    
    if ([data[@"photo"] isKindOfClass:[NSString class]]){
        if ([data[@"photo"] isEqualToString:@""]) {
            NSString *nameGuest = data[@"name"];
            [self.guestImage setImageWithString:nameGuest color:nil circular:YES];
        } else{
            [self.guestImage setImage:circularImageWithImage
             ([UIImage imageWithData: [self decodeBase64ToImage:_data[@"photo"]]])];
        }
    } else {
        self.guestImage.layer.cornerRadius = self.guestImage.frame.size.width/2.0f;
        self.guestImage.clipsToBounds = YES;
        [self.guestImage setImage:data[@"photo"]];
    }
}

static UIImage *circularImageWithImage(UIImage *inputImage)
{
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 20, 160, 160)];
    
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

- (NSData *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

@end
