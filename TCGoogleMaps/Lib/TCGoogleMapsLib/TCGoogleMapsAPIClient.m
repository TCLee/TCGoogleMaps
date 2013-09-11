//
//  TCGoogleMapsAPIClient.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/21/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCGoogleMapsAPIClient.h"

static NSString * const kTCGoogleMapsAPIBaseURLString = @"https://maps.googleapis.com/maps/api/";

@implementation TCGoogleMapsAPIClient

+ (instancetype)defaultClient
{
    static TCGoogleMapsAPIClient *_defaultClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kTCGoogleMapsAPIBaseURLString]];
    });    
    return _defaultClient;
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
    // "sensor" parameter is required for all requests to Google APIs.
    NSMutableDictionary *mutableParameters = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    mutableParameters[@"sensor"] = @"false";
    
    // Create the HTTP request with the given path and parameters.
    NSURLRequest *request = [self requestWithMethod:@"GET"
                                               path:path
                                         parameters:mutableParameters];
    
    NSLog(@"Request URL: %@", [[request URL] absoluteString]);
    
    // Create the HTTP request operation and add it to the queue.
    AFHTTPRequestOperation *requestOperation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        
        completion(operation, responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(operation, nil, error);
    }];
    
    [self enqueueHTTPRequestOperation:requestOperation];
    
    return requestOperation;
}

@end
