//
//  TCPlacesServiceStatus.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/5/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCPlacesServiceStatus.h"

NSString * const TCPlacesServiceStatusOK = @"OK";
NSString * const TCPlacesServiceStatusZeroResults = @"ZERO_RESULTS";
NSString * const TCPlacesServiceStatusOverQueryLimit = @"OVER_QUERY_LIMIT";
NSString * const TCPlacesServiceStatusRequestDenied = @"REQUEST_DENIED";
NSString * const TCPlacesServiceStatusInvalidRequest = @"INVALID_REQUEST";
NSString * const TCPlacesServiceStatusUnknownError = @"UNKNOWN_ERROR";

@implementation TCPlacesServiceStatus

+ (NSString *)descriptionFromStatusCode:(NSString *)statusCode
{
    static NSDictionary *statusDescriptions = nil;
    if (!statusDescriptions) {
        statusDescriptions = @{
            TCPlacesServiceStatusOK: @"The response contains a valid result.",
            TCPlacesServiceStatusZeroResults: @"No result was found for this request.",
            TCPlacesServiceStatusOverQueryLimit: @"The application has gone over its request quota.",
            TCPlacesServiceStatusRequestDenied: @"The application is not allowed to use the Google Places API.",
            TCPlacesServiceStatusInvalidRequest: @"This request was invalid.",
            TCPlacesServiceStatusUnknownError: @"The request could not be processed due to a server error. The request may succeed if you try again."
        };
    }
    return statusDescriptions[statusCode];
}

@end
