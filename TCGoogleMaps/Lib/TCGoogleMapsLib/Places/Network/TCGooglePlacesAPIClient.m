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

+ (instancetype)defaultClient
{
    static TCGooglePlacesAPIClient *_defaultClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kTCGooglePlacesAPIBaseURLString]];
    });
    return _defaultClient;
}

- (AFHTTPRequestOperation *)getPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(TCGoogleMapsAPIClientCallback)completion
{
    // We need an API key to access Google Places APIs.
    NSMutableDictionary *mutableParameters = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    mutableParameters[@"key"] = kTCGooglePlacesAPIKey;
    
    return [super getPath:path parameters:mutableParameters completion:completion];
}

@end
