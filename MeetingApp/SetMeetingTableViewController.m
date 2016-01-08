//
//  SetMeetingTableViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/7/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "SetMeetingTableViewController.h"

@implementation SetMeetingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    self.guests = @[
                    @{
                        @"email" : @"fachinacg@gmail.com",
                        @"name" : @"Estefania Guardado",
                        @"photo" : @"14241341.png"
                        },
                    @{
                        @"email" : @"xlarsx@gmail.com",
                        @"name" : @"Luis Alejandro Rangel",
                        @"photo" : @"14241323.png"
                        },
                    @{
                        @"email" : @"set311@gmail.com",
                        @"name" : @"Jesus Cagide",
                        @"photo" : @"14298723.png"
                        }
                    ];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"Information", @"Information");
            break;
        case 1:
            sectionName = NSLocalizedString(@"Guest", @"Guest");
            break;
        default:
            break;
    }
    return sectionName;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 2;
    
    if (section == 1)
        return [self.guests count];
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IDENTIFIER"];
    
    if(indexPath.section == 0){
        UITextField *informationMeeting = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        informationMeeting.adjustsFontSizeToFitWidth = YES;
        informationMeeting.textColor = [UIColor blackColor];
        if ([indexPath row] == 0) {
            informationMeeting.placeholder = @" ";
            informationMeeting.keyboardType = UIKeyboardTypeEmailAddress;
            informationMeeting.returnKeyType = UIReturnKeyNext;
        }
        else {
            informationMeeting.placeholder = @" ";
            informationMeeting.keyboardType = UIKeyboardTypeDefault;
            informationMeeting.returnKeyType = UIReturnKeyDone;
        }
        
        [informationMeeting setEnabled: YES];
        
        [cell.contentView addSubview:informationMeeting];
        
    }
    if (indexPath.section == 1) {
        cell.imageView.image = [UIImage imageNamed:@"inicio.png"];
    }
    
    if ([indexPath section] == 0) { // Email & Password Section
        if ([indexPath row] == 0) { // Email
            cell.textLabel.text = @"Start: ";
            //cell.textColor = [UIColor grayColor];
        }
        else {
            cell.textLabel.text = @"End: ";
        }
    }
    
    return cell;
}



@end
