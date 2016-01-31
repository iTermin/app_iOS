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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    NSDictionary * dataGuest = self.currentGuest[@"data"];
    [self.nameGuest setText: dataGuest[@"name"]];
    [self.emailGuest setText: dataGuest[@"email"]];
    
    NSString *noPhoto = @"";
    if (dataGuest[@"photo"] == noPhoto) {
        NSString *userName = dataGuest[@"name"];
        [self.guestPhoto setImageWithString:userName color:nil circular:YES];
    } else {
        self.guestPhoto.layer.cornerRadius = self.guestPhoto.frame.size.width/2.0f;
        self.guestPhoto.clipsToBounds = YES;
        NSString *getPhoto = [NSString stringWithFormat:@"%@.png", dataGuest[@"photo"]];
        [self.guestPhoto setImage:[UIImage imageNamed:getPhoto]];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"IDENTIFIER"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

@end
