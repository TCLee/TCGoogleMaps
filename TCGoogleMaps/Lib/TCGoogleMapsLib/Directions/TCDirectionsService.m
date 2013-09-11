//
//  TCDirectionsService.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/24/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCDirectionsService.h"
#import "TCDirectionsParameters.h"
#import "TCDirectionsStatus.h"
#import "TCDirectionsRoute.h"
#import "TCGoogleMapsAPIClient.h"

#import <AFNetworking/AFNetworking.h>

NSString * const TCDirectionsErrorDomain = @"com.tclee.GoogleMaps.TCDirectionsErrorDomain";
NSString * const TCDirectionsStatusCodeErrorKey = @"TCDirectionsStatusCode";

@interface TCDirectionsService ()
@property (nonatomic, strong) AFHTTPRequestOperation *directionsRequestOperation;
@end

@implementation TCDirectionsService

+ (TCDirectionsService *)sharedService
{
    static TCDirectionsService *_sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedService = [[TCDirectionsService alloc] init];
    });
    
    return _sharedService;
}

- (void)routeWithParameters:(TCDirectionsParameters *)parameters
                 completion:(TCDirectionsServiceCallback)completion
{
    NSParameterAssert(parameters);
    NSParameterAssert(completion);
    
    // Cancel any ongoing directions request operation before we begin a new one.
    [self.directionsRequestOperation cancel];        
    
    self.directionsRequestOperation = [[TCGoogleMapsAPIClient defaultClient] getPath:@"directions/json" parameters:[parameters dictionary] completion:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        if (responseObject) {
            [self parseResponse:responseObject completion:completion];
        } else {
            completion(nil, error);
        }
    }];
}

- (void)parseResponse:(NSDictionary *)response completion:(TCDirectionsServiceCallback)completion
{
    NSString *status = [response[@"status"] uppercaseString];
    
    if ([status isEqualToString:TCDirectionsStatusOK]) {
        // Get the array of routes from the JSON response.
        NSArray *routes = [self routesFromResponse:response[@"routes"]];
        completion(routes, nil);
    } else {        
        // Create the NSError object using the status string.
        completion(nil, [self errorFromStatusCode:status]);
    }
}

- (NSError *)errorFromStatusCode:(NSString *)statusCode
{
    NSString *description = [TCDirectionsStatus descriptionForStatusCode:statusCode];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: description,
                               TCDirectionsStatusCodeErrorKey: statusCode};
    NSError *error = [[NSError alloc] initWithDomain:TCDirectionsErrorDomain
                                                code:0 // Error code is not used
                                            userInfo:userInfo];
    return error;
}

- (NSArray *)routesFromResponse:(NSArray *)response
{
    NSMutableArray *routes = [[NSMutableArray alloc] initWithCapacity:[response count]];
    for (NSDictionary *routeResponse in response) {
        TCDirectionsRoute *route = [[TCDirectionsRoute alloc] initWithProperties:routeResponse];
        [routes addObject:route];
    }
    return routes;
}

@end
