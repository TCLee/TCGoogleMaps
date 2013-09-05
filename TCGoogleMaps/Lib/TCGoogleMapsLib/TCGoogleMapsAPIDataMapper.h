//
//  TCGoogleMapsUtility.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/26/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

/**
 * Contains methods to convert values to and from Google Maps APIs.
 */
@interface TCGoogleMapsAPIDataMapper : NSObject

/**
 * Returns a GMSCoordinateBounds instance from the given properties dictionary.
 */
+ (GMSCoordinateBounds *)coordinateBoundsFromProperties:(NSDictionary *)properties;

/**
 * Returns a coordinate created from the given properties dictionary.
 */
+ (CLLocationCoordinate2D)coordinateFromProperties:(NSDictionary *)properties;

/**
 * Returns a string representation of a BOOL value, suitable to be passed as a
 * parameter to Google Maps API services.
 */
+ (NSString *)stringFromBool:(BOOL)boolValue;

/**
 * Returns a string representation of a coordinate, suitable to be passed as a
 * parameter to Google Maps API services.
 * On error, returns nil.
 */
+ (NSString *)stringFromCoordinate:(CLLocationCoordinate2D)coordinate;

@end
