//
//  Header.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/25/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGuestInformation.h"

@protocol IGuestInformationDelegate <NSObject>

- (void) guestInformation: (id<IGuestInformation>) guestDetail
        didChangedInformation: (NSDictionary *) guest;

@end