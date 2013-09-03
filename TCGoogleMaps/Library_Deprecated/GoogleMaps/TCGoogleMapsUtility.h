//
//  TCGoogleMapsUtility.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/26/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Contains helper methods to convert values to and from 
 * Google Maps API services.
 */
@interface TCGoogleMapsUtility : NSObject

/**
 * Returns a coordinate created from the given dictionary representation.
 */
+ (CLLocationCoordinate2D)coordinateFromDictionary:(NSDictionary *)dictionary;

/**
 * Returns a string representation of a BOOL value, suitable to be passed as a
 * parameter to Google Maps API services.
 */
+ (NSString *)stringFromBool:(BOOL)boolValue;

/**
 * Returns a string representation of a coordinate, suitable to be passed as a
 * parameter to Google Maps API services.
 */
+ (NSString *)stringFromCoordinate:(CLLocationCoordinate2D)coordinate;

@end
