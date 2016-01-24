//
//  CountryViewCell.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/24/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountryViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *photoCountry;

@property (strong, nonatomic) IBOutlet UILabel *nameCountry;

@property(nonatomic, weak) NSDictionary * data;



@end

