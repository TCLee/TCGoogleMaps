//
//  TCDirectionsService.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/24/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCDirectionsParameters;

/**
 * Domain representing errors from TCDirectionsService.
 */
FOUNDATION_EXPORT NSString * const TCDirectionsErrorDomain;

/**
 * The NSError userInfo dictionary key used to store and retrieve the 
 * Google Directions API status code.
 */
FOUNDATION_EXPORT NSString * const TCDirectionsStatusCodeErrorKey;

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
 *
 *  @param parameters A TCDirectionsParameters object containing the parameters for the directions request.
 *  @param completion Callback block to execute when direction results are returned.
 */
- (void)routeWithParameters:(TCDirectionsParameters *)parameters
                 completion:(TCDirectionsServiceCallback)completion;

@end
