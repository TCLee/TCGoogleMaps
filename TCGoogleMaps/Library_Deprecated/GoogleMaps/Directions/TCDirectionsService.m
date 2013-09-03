//
//  TCDirectionsService.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/24/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCDirectionsService.h"
#import "TCDirectionsParameters.h"
#import "TCDirectionsRoute.h"
#import "TCGoogleMapsAPIClient.h"

NSString * const TCDirectionsErrorDomain = @"com.tclee.GoogleMaps.TCDirectionsErrorDomain";
NSString * const TCDirectionsStatusErrorKey = @"TCDirectionsStatus";

NSString * const TCDirectionsStatusOK = @"OK";
NSString * const TCDirectionsStatusNotFound = @"NOT_FOUND";
NSString * const TCDirectionsStatusZeroResults = @"ZERO_RESULTS";
NSString * const TCDirectionsStatusMaxWaypointsExceeded = @"MAX_WAYPOINTS_EXCEEDED";
NSString * const TCDirectionsStatusInvalidRequest = @"INVALID_REQUEST";
NSString * const TCDirectionsStatusOverQueryLimit = @"OVER_QUERY_LIMIT";
NSString * const TCDirectionsStatusRequestDenied = @"REQUEST_DENIED";
NSString * const TCDirectionsStatusUnknownError = @"UNKNOWN_ERROR";

@interface TCDirectionsService ()

@property (nonatomic, strong) AFHTTPRequestOperation *directionsRequestOperation;
@property (nonatomic, strong) NSDictionary *statusDescriptions;

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

- (id)init
{
    self = [super init];
    if (self) {        
        // Initialize the descriptions for the status codes returned from Google Directions API.
        _statusDescriptions = @{TCDirectionsStatusNotFound: @"At least one of the locations specified in the requests's origin, destination, or waypoints could not be geocoded.",
                                TCDirectionsStatusZeroResults: @"No route could be found between the origin and destination.",
                                TCDirectionsStatusMaxWaypointsExceeded: @"Too many waypoints were provided in the request. The maximum allowed waypoints is 8, plus the origin, and destination. (Google Maps API for Business customers may contain requests with up to 23 waypoints.)",
                                TCDirectionsStatusInvalidRequest: @"The provided request was invalid. Common causes of this status include an invalid parameter or parameter value.",
                                TCDirectionsStatusOverQueryLimit: @"The service has received too many requests from your application within the allowed time period.",
                                TCDirectionsStatusRequestDenied: @"The service denied use of the directions service by your application.",
                                TCDirectionsStatusUnknownError: @"A directions request could not be processed due to a server error. The request may succeed if you try again."};
    }
    return self;
}

- (void)routeWithParameters:(TCDirectionsParameters *)parameters
                 completion:(TCDirectionsServiceCallback)completion
{
    // Cancel any ongoing directions request operation before we begin a new one.
    [self.directionsRequestOperation cancel];        
    
    self.directionsRequestOperation = [[TCGoogleMapsAPIClient sharedClient] getPath:@"directions/json" parameters:[parameters dictionary] completion:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
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
        completion(nil, [self errorFromStatusString:status]);
    }
}

- (NSError *)errorFromStatusString:(NSString *)status
{
    NSString *description = self.statusDescriptions[status];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: description,
                               TCDirectionsStatusErrorKey: status};
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
