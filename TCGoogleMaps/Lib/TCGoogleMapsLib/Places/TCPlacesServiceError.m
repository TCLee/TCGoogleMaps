//
//  TCPlacesServiceError.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/5/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCPlacesServiceError.h"
#import "TCPlacesServiceStatusCode.h"
#import "TCPlacesServiceErrorConstants.h"

@implementation TCPlacesServiceError

+ (NSString *)descriptionFromStatusCode:(NSString *)statusCode
{
    static NSDictionary *statusDescriptions = nil;
    if (!statusDescriptions) {
        statusDescriptions = @{
            TCPlacesServiceStatusZeroResults: @"No result was found for this request.",
            TCPlacesServiceStatusOverQueryLimit: @"The application has gone over its request quota.",
            TCPlacesServiceStatusRequestDenied: @"The application is not allowed to use the Google Places API.",
            TCPlacesServiceStatusInvalidRequest: @"This request was invalid.",
            TCPlacesServiceStatusUnknownError: @"The request could not be processed due to a server error. The request may succeed if you try again."
        };
    }
    return statusDescriptions[statusCode];
}

+ (NSError *)errorWithStatusCode:(NSString *)statusCode
{
    NSString *description = [[self class] descriptionFromStatusCode:statusCode];
    NSAssert(description, @"Cannot create NSError object from an invalid status code.");
    
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey: description,
        TCPlacesServiceStatusCodeErrorKey: statusCode
    };    
    NSError *error = [[NSError alloc] initWithDomain:TCPlacesServiceErrorDomain
                                                code:0 // Error code is not used
                                            userInfo:userInfo];
    return error;
}

@end
