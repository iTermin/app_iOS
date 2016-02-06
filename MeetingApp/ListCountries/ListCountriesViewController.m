//
//  ListCountriesViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/24/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "ListCountriesViewController.h"

@implementation ListCountriesViewController

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
    
    NSMutableArray * viewModel = [NSMutableArray array];
    [self.dataModel[@"countries"] enumerateObjectsUsingBlock:^(NSDictionary * country, NSUInteger idx, BOOL * stop) {
        
        NSMutableDictionary * cellModel = [NSMutableDictionary dictionaryWithDictionary:country];
        //UIImage *flagIcon = [UIImage imageNamed:@"CN"];
        
        UIImage * flagIcon = [UIImage imageNamed: [NSString stringWithFormat:@"%@.png", country[@"code"]]];
        if(flagIcon) [cellModel setObject:flagIcon forKey:@"flagIcon"];
        
        [viewModel addObject:@{
                               @"nib" : @"CountryViewCell",
                               @"height" : @(60),
                               @"data":cellModel }];
    }];
    
    self.viewModel = viewModel;
    
    __weak UITableView * tableView = self.tableView;
    NSMutableSet * registeredNibs = [NSMutableSet set];
    
    [self.viewModel enumerateObjectsUsingBlock:^(NSDictionary * cellViewModel, NSUInteger idx, BOOL * stop) {
        
        NSString * nibFile = cellViewModel[@"nib"];
        
        if(![registeredNibs containsObject: nibFile]) {
            [registeredNibs addObject: nibFile];
            
            UINib * nib = [UINib nibWithNibName:nibFile bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:nibFile];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * cellViewModel = self.viewModel[indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: cellViewModel[@"nib"]];
    
    if([cell respondsToSelector:@selector(setData:)]) {
        [cell performSelector:@selector(setData:) withObject:cellViewModel[@"data"]];
    }
    [cell setAccessoryType: UITableViewCellAccessoryCheckmark];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * cellViewModel = self.viewModel[indexPath.row];
    return [cellViewModel[@"height"] floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * country = [self getCountryAtIndex:indexPath.row];
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
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"%@", country);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSArray *countries = [self.dataModel[@"countries"] valueForKeyPath:@"name"];
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

- (void) deselectedCell:(NSString*)countrySelectedBefore{

}

- (NSDictionary *) getCountryAtIndex:(NSUInteger)index{
    return self.dataModel[@"countries"][index];
}

@end

