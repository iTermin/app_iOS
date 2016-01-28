//
//  ContactsTableViewController.h
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/26/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ContactsTableViewController : UITableViewController <ABPeoplePickerNavigationControllerDelegate>

-(void)accessGrantedForAddressBook;

@end
