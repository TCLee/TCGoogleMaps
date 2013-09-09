//
//  TCPlacesServiceError.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/5/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCPlacesServiceError.h"
#import "TCPlacesServiceStatus.h"
#import "TCPlacesServiceErrorConstants.h"

@implementation TCPlacesServiceError

+ (NSError *)errorWithStatusCode:(NSString *)statusCode
{
    NSString *description = [TCPlacesServiceStatus descriptionFromStatusCode:statusCode];
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
