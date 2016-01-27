//
//  ContactsTableViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/26/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//
#import <Contacts/Contacts.h>

#import "ContactsTableViewController.h"

@interface ContactsTableViewController () <UISplitViewControllerDelegate>

@property (nonatomic,strong) NSMutableArray *groupOfContacts;
@property (nonatomic,strong) NSMutableArray *phoneNumerArray;

@end

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.groupOfContacts = [@[] mutableCopy];
    [self getAllContact];
    
    self.phoneNumerArray = [@[] mutableCopy];
    for (CNContact *contact in self.groupOfContacts){
        NSArray *thisOne = [[contact.phoneNumbers valueForKey:@"value"] valueForKey:@"digits"];
        [self.phoneNumerArray addObjectsFromArray:thisOne];
    }
    
    //NSLog(@"%@", self.groupOfContacts);
}

- (void) getAllContact{
    if ([CNContactStore class]) {
        CNContactStore *addressBook = [[CNContactStore alloc]init];
        
        NSArray *KeyToFetch = @[CNContactEmailAddressesKey,
                                CNContactFamilyNameKey,
                                CNContactGivenNameKey,
                                CNContactPhoneNumbersKey,
                                CNContactPostalAddressesKey];
        
        CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:KeyToFetch];
        
        [addressBook enumerateContactsWithFetchRequest:fetchRequest
                                                 error:nil usingBlock:^(CNContact * const contact, BOOL * _Nonnull stop) {
                                                     [self.groupOfContacts addObject:contact];
                                                 }];
        NSLog(@"%@", self.groupOfContacts);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IDENTIFIER"];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
