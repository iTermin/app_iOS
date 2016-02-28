//
//  ViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 12/26/15.
//  Copyright © 2015 Estefania Chavez Guardado. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "ModelTableViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "Meeting.h"

@interface MeetingTableViewController : ModelTableViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(strong) NSArray<Meeting *> *meetings;

@end

