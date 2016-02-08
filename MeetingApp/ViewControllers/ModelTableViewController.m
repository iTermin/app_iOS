//
//  ModelTableViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 2/8/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "ModelTableViewController.h"

@interface ModelTableViewController ()

@property(nonatomic, strong) NSMutableSet * registeredNibs;

@end

@implementation ModelTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.registeredNibs = [NSMutableSet set];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * cellViewModel = self.viewModel[indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: cellViewModel[@"nib"]];
    
    if([cell respondsToSelector:@selector(setData:)]) {
        [cell performSelector:@selector(setData:) withObject:cellViewModel[@"data"]];
    }
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 365, .5)];/// change size as you need.
    separatorLineView.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:separatorLineView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * cellViewModel = self.viewModel[indexPath.row];
    return [cellViewModel[@"height"] floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    NSDictionary * cellModel = self.viewModel[indexPath.row];
    NSString * segueToPerform = cellModel[@"segue"];
    if(segueToPerform) {
        [self performSegueWithIdentifier: segueToPerform
                                  sender: cellModel[@"data"]];
    }
}

- (void) updateViewModel {
    __weak UITableView * tableView = self.guestsTableView;
    [self.viewModel enumerateObjectsUsingBlock:^(NSDictionary * cellViewModel, NSUInteger idx, BOOL * stop) {
        
        NSString * nibFile = cellViewModel[@"nib"];
        
        if(![self.registeredNibs containsObject: nibFile]) {
            [self.registeredNibs addObject: nibFile];
            
            UINib * nib = [UINib nibWithNibName:nibFile bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:nibFile];
        }
    }];
}

@end
