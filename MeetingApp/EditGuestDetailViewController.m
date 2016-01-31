//
//  EditGuestDetailViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 1/31/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "EditGuestDetailViewController.h"
#import "UIImageView+Letters.h"

@interface EditGuestDetailViewController ()

@end

@implementation EditGuestDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.nameGuest setText: self.currentGuest[@"name"]];
    [self.emailGuest setText: self.currentGuest[@"email"]];
    
    NSString *noPhoto = @"";
    if (self.currentGuest[@"photo"] == noPhoto) {
        NSString *userName = self.currentGuest[@"name"];
        [self.guestPhoto setImageWithString:userName color:nil circular:YES];
    } else {
        self.guestPhoto.layer.cornerRadius = self.guestPhoto.frame.size.width/2.0f;
        self.guestPhoto.clipsToBounds = YES;
        NSString *getPhoto = [NSString stringWithFormat:@"%@.png", self.currentGuest[@"photo"]];
        [self.guestPhoto setImage:[UIImage imageNamed:getPhoto]];
    }
    
    self.viewModel =
    @[
      @{
          @"nib" : @"LocationUserTableViewCell",
          @"height" : @(80),
          @"data": [self.currentGuest copy]
          }
      ];
    
    __weak UITableView * tableView = self.locationGuest;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary * cellViewModel = self.viewModel[indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: cellViewModel[@"nib"]];
    
    if([cell respondsToSelector:@selector(setData:)]) {
        [cell performSelector:@selector(setData:) withObject:cellViewModel[@"data"]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * cellViewModel = self.viewModel[indexPath.row];
    return [cellViewModel[@"height"] floatValue];
}

@end
