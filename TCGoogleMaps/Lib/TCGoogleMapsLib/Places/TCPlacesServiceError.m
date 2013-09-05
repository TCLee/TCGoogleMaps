//
//  TCPlacesServiceError.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/5/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCPlacesServiceError.h"
#import "TCPlacesServiceStatus.h"

NSString * const TCPlacesServiceErrorDomain = @"com.tclee.TCGoogleMapsLib.TCPlacesServiceErrorDomain";
NSString * const TCPlacesServiceStatusCodeErrorKey = @"TCPlacesServiceStatusCode";

@implementation TCPlacesServiceError

+ (NSError *)errorWithStatusCode:(NSString *)statusCode
{
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey: [TCPlacesServiceStatus descriptionFromStatusCode:statusCode],
        TCPlacesServiceStatusCodeErrorKey: statusCode
    };    
    NSError *error = [[NSError alloc] initWithDomain:TCPlacesServiceErrorDomain
                                                code:0 // Error code is not used
                                            userInfo:userInfo];
    return error;
}

@end
