//
//  MeetingTableViewCell.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/6/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingTableViewCell : UITableViewCell

@property(nonatomic, weak) NSDictionary * data;

@property (strong, nonatomic) IBOutlet UIImageView *imageMeeting;
@property (strong, nonatomic) IBOutlet UILabel *nameMeeting;
@property (strong, nonatomic) IBOutlet UILabel *dateMeeting;

@end
