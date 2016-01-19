//
//  HeaderTableViewCell.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/19/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderTableViewCell : UITableViewCell

@property(nonatomic, weak) NSDictionary * data;

@property (weak, nonatomic) IBOutlet UILabel *headerText;


@end
