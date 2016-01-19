//
//  MeetingDetailViewController.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 12/28/15.
//  Copyright © 2015 Estefania Chavez Guardado. All rights reserved.
//

#import "MeetingDetailViewController.h"
#import "GuestDetailViewController.h"

@interface MeetingDetailViewController ()

@property (weak, nonatomic) IBOutlet UIButton *pushNotification;
@property (weak, nonatomic) IBOutlet UIButton *emailNotification;
@property (weak, nonatomic) IBOutlet UIButton *reminderNotification;
@property (weak, nonatomic) IBOutlet UIButton *calendarNotification;

@end

@implementation MeetingDetailViewController

@synthesize pushNotification;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.guests = @[
                      @{
                          @"email" : @"fachinacg@gmail.com",
                          @"name" : @"Estefania Guardado",
                          @"photo" : @"14241341.png"
                          },
                      @{
                          @"email" : @"xlarsx@gmail.com",
                          @"name" : @"Luis Alejandro Rangel",
                          @"photo" : @"14241323.png"
                          },
                      @{
                          @"email" : @"set311@gmail.com",
                          @"name" : @"Jesus Cagide",
                          @"photo" : @"14298723.png"
                          }
                      ];
    
    [self.pushNotification addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.calendarNotification addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.reminderNotification addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.emailNotification addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
}


-(void)buttonTouchDown:(UIButton *)button{
    UIColor *pressed = [UIColor colorWithRed:1 green:0.412 blue:0.412 alpha:1];
    UIColor *colorButton = button.backgroundColor;
    
    if (colorButton == pressed) {
        button.backgroundColor = [UIColor colorWithRed:0.608 green:0.608 blue:0.608 alpha:1];
    } else {
        button.backgroundColor = [UIColor colorWithRed:1 green:0.412 blue:0.412 alpha:1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self.timeOfMeeting setText: self.currentMeeting[@"date"]];
}

- (IBAction)pushButtonPressed:(id)sender {
}

- (IBAction)reminderNotificationPressed:(id)sender{
}

- (IBAction)emailNotificationPressed:(id)sender{
}

- (IBAction)calendarNotificationPressed:(id)sender{
}

- (IBAction)buttonPressed:(id)sender {
    UIButton *buttonPress = (UIButton *)sender;
    NSString *identifier = buttonPress.restorationIdentifier;

    NSLog(identifier);

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Alert"
                                                                   message:@"This is an action sheet."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) { NSLog(@"You pressed button OK");
    }];
        
    [alert addAction:firstAction];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.guests count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"IDENTIFIER"];
    cell.textLabel.font = [UIFont fontWithName:@"BodoniSvtyTwoITCTT-Bold" size:15];
    cell.detailTextLabel.font = [UIFont fontWithName:@"BodoniSvtyTwoITCTT-Book" size:11];
    [[cell textLabel] setText: self.guests[indexPath.row][@"name"]];
    [[cell detailTextLabel] setText: self.guests[indexPath.row][@"email"] ];
    [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    NSDictionary * selectedMeeting = self.guests[indexPath.row];
    [self performSegueWithIdentifier:@"guestDetail" sender: selectedMeeting];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary *)sender {
    GuestDetailViewController * guestDetailViewController = (GuestDetailViewController *)segue.destinationViewController;
    [guestDetailViewController setTitle:sender[@"name"]];
    [guestDetailViewController setCurrentGuest: sender];
}

@end
