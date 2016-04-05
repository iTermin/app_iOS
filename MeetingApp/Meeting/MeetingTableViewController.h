//
//  ViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 12/26/15.
//  Copyright © 2015 Estefania Chavez Guardado. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>

#import "ModelTableViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "Meeting.h"
#import "IMeetingDelegate.h"
#import "IMeetingDatasource.h"
#import "IUserDatasource.h"
#import "IUserDelegate.h"

@interface MeetingTableViewController : ModelTableViewController
<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, SWTableViewCellDelegate>

@property(strong) NSArray<Meeting *> *meetings;
@property (weak) id<IMeetingDelegate, IMeetingDatasource> meetingbusiness;
@property (weak) id<IUserDelegate, IUserDatasource> userbusiness;

- (IBAction)reloadData:(id)sender;
@end

