//
//  TCDistance.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/25/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 * A representation of distance as a numeric value and a display string.
 */
@interface TCDistance : NSObject

/**
 * A string representation of the distance value, using the UnitSystem 
 * specified in the request.
 */
@property (nonatomic, copy, readonly) NSString *text;

/**
 * The distance in meters.
 */
@property (nonatomic, assign, readonly) CLLocationDistance value;

/**
 * Initializes a newly allocated TCDistance object with results
 * returned from TCDirectionsService.
 * You don't instantiate this class directly; use TCDirectionsService to
 * obtain an instance.
 */
- (id)initWithProperties:(NSDictionary *)properties;

@end
