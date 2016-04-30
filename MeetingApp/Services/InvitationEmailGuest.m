//
//  InvitationEmailGuest.m
//  MeetingApp
//
//  Created by Estefania Chavez Guardado on 4/30/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "InvitationEmailGuest.h"

@implementation InvitationEmailGuest


- (void) sendInvitationToGuestOfMeeting: (NSString *) meetingId {
    NSDictionary *headers = @{ @"content-type": @"application/x-www-form-urlencoded",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"aac90afb-bdb1-ccce-8f41-1b9cb31110fd" };
    
    NSMutableData *postData = [[NSMutableData alloc] initWithData:[meetingId dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://blueberry-crumble-60073.herokuapp.com/meeting"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                    }
                                                }];
    [dataTask resume];
}

@end
