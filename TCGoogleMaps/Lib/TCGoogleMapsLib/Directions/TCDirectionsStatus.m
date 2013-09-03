//
//  TCDirectionsStatus.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/29/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCDirectionsStatus.h"

NSString * const TCDirectionsStatusOK = @"OK";
NSString * const TCDirectionsStatusNotFound = @"NOT_FOUND";
NSString * const TCDirectionsStatusZeroResults = @"ZERO_RESULTS";
NSString * const TCDirectionsStatusMaxWaypointsExceeded = @"MAX_WAYPOINTS_EXCEEDED";
NSString * const TCDirectionsStatusInvalidRequest = @"INVALID_REQUEST";
NSString * const TCDirectionsStatusOverQueryLimit = @"OVER_QUERY_LIMIT";
NSString * const TCDirectionsStatusRequestDenied = @"REQUEST_DENIED";
NSString * const TCDirectionsStatusUnknownError = @"UNKNOWN_ERROR";

@implementation TCDirectionsStatus

+ (NSString *)descriptionForStatusCode:(NSString *)statusCode
{
    static NSDictionary *statusDescriptions = nil;
    if (!statusDescriptions) {
        // Initialize the descriptions for the status codes returned from Google Directions API.
        statusDescriptions = @{TCDirectionsStatusOK: @"The response contains a valid directions result.",
                               TCDirectionsStatusNotFound: @"At least one of the locations specified in the requests's origin, destination, or waypoints could not be geocoded.",
                               TCDirectionsStatusZeroResults: @"No route could be found between the origin and destination.",
                               TCDirectionsStatusMaxWaypointsExceeded: @"Too many waypoints were provided in the request. The maximum allowed waypoints is 8, plus the origin, and destination. (Google Maps API for Business customers may contain requests with up to 23 waypoints.)",
                               TCDirectionsStatusInvalidRequest: @"The provided request was invalid. Common causes of this status include an invalid parameter or parameter value.",
                               TCDirectionsStatusOverQueryLimit: @"The service has received too many requests from your application within the allowed time period.",
                               TCDirectionsStatusRequestDenied: @"The service denied use of the directions service by your application.",
                               TCDirectionsStatusUnknownError: @"A directions request could not be processed due to a server error. The request may succeed if you try again."};
    }    
    return statusDescriptions[statusCode];
}

@end
