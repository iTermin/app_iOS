//
//  GuestListCountriesTableViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/5/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "GuestListCountriesTableViewController.h"

@interface GuestListCountriesTableViewController ()

@end

@implementation GuestListCountriesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataModel = @{
                       @"countries" : @[
                               @{
                                   @"name": @"China",
                                   @"dial_code": @"+86",
                                   @"code": @"CN"
                                   },
                               @{
                                   @"name": @"France",
                                   @"dial_code": @"+33",
                                   @"code": @"FR"
                                   },
                               @{
                                   @"name": @"Germany",
                                   @"dial_code": @"+49",
                                   @"code": @"DE"
                                   },
                               @{
                                   @"name": @"India",
                                   @"dial_code": @"+91",
                                   @"code": @"IN"
                                   },
                               @{
                                   @"name": @"Italy",
                                   @"dial_code": @"+39",
                                   @"code": @"IT"
                                   },
                               @{
                                   @"name": @"Japan",
                                   @"dial_code": @"+81",
                                   @"code": @"JP"
                                   },
                               @{
                                   @"name": @"Mexico",
                                   @"dial_code": @"+52",
                                   @"code": @"MX"
                                   },
                               @{
                                   @"name": @"United Kingdom",
                                   @"dial_code": @"+44",
                                   @"code": @"GB"
                                   },
                               @{
                                   @"name": @"United States",
                                   @"dial_code": @"+1",
                                   @"code": @"US"
                                   }
                               ]};
    
    [self updateViewModel];
    
}

-(void) updateViewModel{
    NSMutableArray * viewModel = [NSMutableArray array];
    [self.dataModel[@"countries"] enumerateObjectsUsingBlock:^(NSDictionary * country, NSUInteger idx, BOOL * stop) {
        
        NSMutableDictionary * cellModel = [NSMutableDictionary dictionaryWithDictionary:country];
        
        UIImage * flagIcon = [UIImage imageNamed: [NSString stringWithFormat:@"%@.png", country[@"code"]]];
        if(flagIcon) [cellModel setObject:flagIcon forKey:@"flagIcon"];
        
        [viewModel addObject:@{
                               @"nib" : @"CountryViewCell",
                               @"height" : @(60),
                               @"data":cellModel }];
    }];
    
    self.viewModel = viewModel;
    
    [super updateViewModel];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * country = [self getCountryAtIndex:indexPath.row];
    /*
    if (country[@"name"] != self.currentGuest[@"nameCountry"]) {
        NSArray *countries = [self.dataModel[@"countries"] valueForKeyPath:@"name"];
        int indice=0;
        for ( ; indice < countries.count; ++indice) {
            if (countries[indice] == self.currentGuest[@"nameCountry"]) {
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:indice inSection:0];
                [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                
                break;
            }
        }
    }*/
    [self.navigationController popViewControllerAnimated:YES];
    
    NSLog(@"%@", country);
}

- (void) configureCell: (UITableViewCell *) cell withModel: (NSDictionary *) cellModel {
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSArray *countries = [self.dataModel[@"countries"] valueForKeyPath:@"name"];
    int indice=0;
    for ( ; indice < countries.count; ++indice) {
        if (countries[indice] == self.currentGuest[@"nameCountry"]) {
            //NSLog(@"%@", prueba[i]);
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:indice inSection:0];
            [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        }
    }
    
}

- (NSDictionary *) getCountryAtIndex:(NSUInteger)index{
    return self.dataModel[@"countries"][index];
}

@end
