//
//  TCGoogleMapsAPIClient.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/21/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCGoogleMapsAPIClient.h"

static NSString * const kTCGoogleMapsAPIBaseURLString = @"https://maps.googleapis.com/maps/api/";
static NSString * const kTCGoogleMapsAPIKey = @"AIzaSyBDNqerk86QTl8UV-lz2l5y1vga9OsItq8";

@implementation TCGoogleMapsAPIClient

+ (TCGoogleMapsAPIClient *)sharedClient
{
    static TCGoogleMapsAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[TCGoogleMapsAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kTCGoogleMapsAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
    return self;
}

- (AFHTTPRequestOperation *)getPath:(NSString *)path
                         parameters:(NSDictionary *)parameters
                         completion:(TCGoogleMapsAPIClientCallback)completion
{
    // Add the "sensor" and "key" parameters to the list of other parameters.
    NSMutableDictionary *modifiedParameters = [parameters mutableCopy];
    modifiedParameters[@"sensor"] = @"false";
    modifiedParameters[@"key"] = kTCGoogleMapsAPIKey;
    
    // Create the HTTP request with the given path and parameters.
    NSURLRequest *request = [self requestWithMethod:@"GET"
                                               path:path
                                         parameters:[modifiedParameters copy]];
    
    // Create the HTTP request operation and add it to the queue.
    AFHTTPRequestOperation *requestOperation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(operation, responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(operation, nil, error);
    }];
    
    [self enqueueHTTPRequestOperation:requestOperation];
    
    return requestOperation;
}

@end
