//
//  GuestListCountriesTableViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/5/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "GuestListCountriesTableViewController.h"
#import "ArrayOfCountries.h"

@interface GuestListCountriesTableViewController ()

@end

@implementation GuestListCountriesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayCountries = [ArrayOfCountries new];
    self.modelCountries = [self.arrayCountries getModelCountries];
    
    [self updateViewModel];
    
}

-(void) updateViewModel{
    NSMutableArray * viewModel = [NSMutableArray array];
    [self.modelCountries enumerateObjectsUsingBlock:^(NSDictionary * country, NSUInteger idx, BOOL * stop) {
        
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
    [self.countrySelectorDelegate countrySelector:self didSelectCountry:country];
}

- (void) configureCell: (UITableViewCell *) cell withModel: (NSDictionary *) cellModel {
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSArray *countries = [self.modelCountries valueForKeyPath:@"name"];
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
    return self.modelCountries[index];
}

@end
