//
//  ViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 12/26/15.
//  Copyright © 2015 Estefania Chavez Guardado. All rights reserved.
//

#import "ModelTableViewController.h"
#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"

@interface MeetingTableViewController : ModelTableViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(strong) NSArray *meetings;

@end

