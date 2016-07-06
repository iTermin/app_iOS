//
//  ContactAddress.h
//  Prueba
//
//  Created by Estefania Chavez Guardado on 7/4/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

#import "IContactInformation.h"

@interface ContactAddress : NSObject <CNContactViewControllerDelegate, CNContactPickerDelegate>

@property (weak) UIViewController * viewController;

@property (weak) id<IContactInformation> contactInformation;

- (void) contactScan;

@end
