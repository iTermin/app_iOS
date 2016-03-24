//
//  ListCountriesViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/24/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "ListCountriesViewController.h"
#import "ArrayOfCountries.h"

@implementation ListCountriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayCountries = [ArrayOfCountries new];
    self.modelCountries = [self.arrayCountries getModelCountries];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self updateViewModel];
    
}

- (void) updateViewModel{
    NSMutableArray * viewModel = [NSMutableArray array];
    [self.modelCountries enumerateObjectsUsingBlock:^(NSDictionary * country, NSUInteger idx, BOOL * stop) {
        
        NSMutableDictionary * cellModel = [NSMutableDictionary dictionaryWithDictionary:country];
        //UIImage *flagIcon = [UIImage imageNamed:@"CN"];
        
        UIImage * flagIcon = [UIImage imageNamed: [NSString stringWithFormat:@"%@.png", country[@"code"]]];
        if(flagIcon) [cellModel setObject:flagIcon forKey:@"flagIcon"];
        
        [viewModel addObject:@{
                               @"nib" : @"CountryViewCell",
                               @"height" : @(70),
                               @"data":cellModel }];
    }];
    
    self.viewModel = viewModel;
    
    [super updateViewModel];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * country = [self getCountryAtIndex:indexPath.row];
    [self.countrySelectorDelegate countrySelector:self didSelectCountry:country];
    /*
     if (country[@"name"] != self.currentLocation) {
     NSArray *countries = [self.dataModel[@"countries"] valueForKeyPath:@"name"];
     int indice=0;
     for ( ; indice < countries.count; ++indice) {
     if (countries[indice] == self.currentLocation) {
     NSIndexPath *indexPath=[NSIndexPath indexPathForRow:indice inSection:0];
     [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
     
     break;
     }
     }
     }*/
}

- (void) configureCell: (UITableViewCell *) cell withModel: (NSDictionary *) cellModel {}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSArray *countries = [self.modelCountries valueForKeyPath:@"name"];
    int indice=0;
    for ( ; indice < countries.count; ++indice) {
        if (countries[indice] == self.currentLocation) {
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

