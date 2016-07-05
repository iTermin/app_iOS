//
//  ContactAddress.m
//  Prueba
//
//  Created by Estefania Chavez Guardado on 7/4/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

#import "ContactAddress.h"

@implementation ContactAddress

- (void) alertAccesDenied {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Privacy Warning."
                                message:@"Permission was not granted for Contacts."
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action){
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    
    [alert addAction:ok];
    [self.viewController presentViewController:alert animated:YES completion:nil];
}

- (void) contactScan {
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (status) {
        case CNAuthorizationStatusNotDetermined:
        {
            CNContactStore *store = [CNContactStore new];
            [store requestAccessForEntityType:CNEntityTypeContacts
                            completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                if (!granted)
                                    [self alertAccesDenied];
                                else {
                                    [self accessGrantedForAddressBook];
                                }
                            }];
        }
            break;
        //case CNAuthorizationStatusRestricted:
        //case CNAuthorizationStatusDenied:
        case CNAuthorizationStatusAuthorized:
            [self accessGrantedForAddressBook];
            break;
            
        default:
            break;
    }
}

-(void)accessGrantedForAddressBook
{
    CNContactStore *store = [CNContactStore new];
    NSError *error;
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactNoteKey,CNContactPhoneNumbersKey]];
    NSMutableArray *people = @[].mutableCopy;
    BOOL success = [store enumerateContactsWithFetchRequest:request error:&error
                                                 usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                                                     [people addObject:contact];
                                                 }];
    
    if (success) {
        [self showPeoplePickerController];
    } else {
        NSLog(@"%s %@",__func__, error);
    }
    
}

-(void)showPeoplePickerController
{
    CNContactPickerViewController * contactPicker = [CNContactPickerViewController new];
    contactPicker.delegate = self;
    
    contactPicker.displayedPropertyKeys = (NSArray *)CNContactGivenNameKey;
    
    [self.viewController presentViewController:contactPicker animated:YES completion:nil];
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(nonnull CNContact *)contact{
    [self.viewController dismissViewControllerAnimated:YES completion:^{
        [self parseContactWithContact:contact];
    }];
}

- (void)parseContactWithContact :(CNContact* )contact
{
    NSString * name = [[contact.givenName stringByAppendingString:@" " ] stringByAppendingString:contact.familyName];
    NSArray * phone = [[contact.phoneNumbers valueForKey:@"value"] valueForKey:@"digits"];
    NSArray * email = [contact.emailAddresses valueForKey:@"value"];
    UIImage *image = [UIImage imageWithData:contact.imageData];
    NSString * stringImage = [self encodeToBase64String:image];
    
    NSDictionary * contactInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [name isEqualToString:@""] ? @"" : name, @"name",
                                  [phone isEqualToArray:@[]] ? @[] : phone, @"phone",
                                  [email isEqualToArray:@[]] ? @"" : email[0], @"email",
                                  [stringImage isEqualToString:@""] ? @"" : stringImage, @"image", nil];
    
    [self.contactInformation getContactSelected:contactInfo];
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image)
            base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

@end
