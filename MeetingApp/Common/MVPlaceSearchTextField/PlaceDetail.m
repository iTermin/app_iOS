//
//  PlaceDetail.m
//  PlaceSearchAPIDEMO
//
//  Created by Mrugrajsinh Vansadia on 26/04/14.
//  Copyright (c) 2014 Mrugrajsinh Vansadia. All rights reserved.
//

#import "PlaceDetail.h"

#define apiURL @"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=%@"
#define apiURLWithoutKey @"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true"
@implementation PlaceDetail
-(id)initWithApiKey:(NSString *)ApiKey{
    
    self = [super init];
    if (self) {
        aStrApiKey=ApiKey;
    }
    return self;
}

-(void)getPlaceDetailForReferance:(NSString*)strReferance{
    NSString *aStrUrl=aStrApiKey?[NSString stringWithFormat:apiURL,strReferance,aStrApiKey]:[NSString stringWithFormat:apiURLWithoutKey,strReferance];
    NSURL *aUrl=[NSURL URLWithString:aStrUrl];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        [self returnDictionaryDataWithURL:aUrl withResponseCallback:^(NSDictionary * dictionaryData) {
            [_delegate placeDetailForReferance:strReferance didFinishWithResult:[NSMutableDictionary dictionaryWithDictionary:dictionaryData]];
        }];
    });
    
}

- (void) returnDictionaryDataWithURL: (NSURL *) url withResponseCallback: (void (^)(NSDictionary *)) callback{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];
    NSURLSession * sesion = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask * task = [sesion dataTaskWithRequest:urlRequest
                                            completionHandler:^(NSData * data,
                                                                NSURLResponse * response,
                                                                NSError * error) {
                                                NSDictionary * dictionaryWithData = nil;
                                                if(!error && data) {
                                                    dictionaryWithData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                                }
                                                callback(dictionaryWithData);
                                            }];
    
    [task resume];
}

@end
