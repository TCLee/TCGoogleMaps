//
//  TCDirectionsStatus.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/29/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const TCDirectionsStatusOK;
FOUNDATION_EXPORT NSString * const TCDirectionsStatusNotFound;
FOUNDATION_EXPORT NSString * const TCDirectionsStatusZeroResults;
FOUNDATION_EXPORT NSString * const TCDirectionsStatusMaxWaypointsExceeded;
FOUNDATION_EXPORT NSString * const TCDirectionsStatusInvalidRequest;
FOUNDATION_EXPORT NSString * const TCDirectionsStatusOverQueryLimit;
FOUNDATION_EXPORT NSString * const TCDirectionsStatusRequestDenied;
FOUNDATION_EXPORT NSString * const TCDirectionsStatusUnknownError;

/**
 * Maps the Google Direction's API status code to an appropriate description 
 * used for error messages.
 */
@interface TCDirectionsStatus : NSObject

/**
 * Returns the description string for the given status code returned from
 * Google Directions API.
 *
 * @param statusCode the status code returned in the response by Google Directions API.
 *
 * @return a string describing the status code. If status code is not one of the
 *         TCDirectionStatus constants, it will return nil.
 */
+ (NSString *)descriptionForStatusCode:(NSString *)statusCode;

@end
