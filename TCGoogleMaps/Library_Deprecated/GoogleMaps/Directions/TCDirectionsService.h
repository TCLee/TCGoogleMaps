//
//  TCDirectionsService.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/24/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

@class TCDirectionsParameters;

/**
 * Domain representing errors from TCDirectionsService.
 */
FOUNDATION_EXPORT NSString * const TCDirectionsErrorDomain;

/**
 * The NSError userInfo dictionary key used to store and retrieve the 
 * Google Directions API status code.
 */
FOUNDATION_EXPORT NSString * const TCDirectionsStatusErrorKey;

/**
 * Status codes returned by Google Directions API service.
 */
FOUNDATION_EXPORT NSString * const TCDirectionsStatusOK;
FOUNDATION_EXPORT NSString * const TCDirectionsStatusNotFound;
FOUNDATION_EXPORT NSString * const TCDirectionsStatusZeroResults;
FOUNDATION_EXPORT NSString * const TCDirectionsStatusMaxWaypointsExceeded;
FOUNDATION_EXPORT NSString * const TCDirectionsStatusInvalidRequest;
FOUNDATION_EXPORT NSString * const TCDirectionsStatusOverQueryLimit;
FOUNDATION_EXPORT NSString * const TCDirectionsStatusRequestDenied;
FOUNDATION_EXPORT NSString * const TCDirectionsStatusUnknownError;

/**
 * Callback block for when Google Directions API has calculated directions 
 * between the given locations.
 *
 * @param routes The array of TCDirectionsRoute objects representing the 
 *               possible routes from origin to destination. On error, this 
 *               parameter will be nil.
 * @param error The NSError object describing why the Google Directions API request failed.
 *              Use the TCDirectionsStatusErrorKey on the userInfo dictionary to get the 
 *              Google Directions API status code.
 */
typedef void (^TCDirectionsServiceCallback)(NSArray *routes, NSError *error);

/**
 * Provides access to Google Directions API service.
 */
@interface TCDirectionsService : NSObject

/**
 * Returns the shared instance of TCDirectionsService to access
 * Google Directions API.
 */
+ (TCDirectionsService *)sharedService;

/**
 * Issue a directions search request.
 */
- (void)routeWithParameters:(TCDirectionsParameters *)parameters
                 completion:(TCDirectionsServiceCallback)completion;

@end
