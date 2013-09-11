//
//  TCGooglePlacesAPIClient.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/10/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCGooglePlacesAPIClient.h"
#import "TCGoogleAPIKeys.h"

static NSString * const kTCGooglePlacesAPIBaseURLString = @"https://maps.googleapis.com/maps/api/place/";

@implementation TCGooglePlacesAPIClient

+ (TCGooglePlacesAPIClient *)sharedClient
{
    static TCGooglePlacesAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[TCGooglePlacesAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kTCGooglePlacesAPIBaseURLString]];
    });    
    return _sharedClient;    
}

- (AFHTTPRequestOperation *)getPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(TCGoogleMapsAPIClientCallback)completion
{
    // We need an API key to access Google Places services.
    NSMutableDictionary *mutableParameters = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    mutableParameters[@"key"] = kTCGooglePlacesAPIKey;
    
    return [super getPath:path parameters:mutableParameters completion:completion];
}

@end
