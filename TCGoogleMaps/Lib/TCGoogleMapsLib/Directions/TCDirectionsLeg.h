//
//  TCDirectionsLeg.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/24/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class TCDistance;
@class TCDuration;

/**
 * Each TCDirectionsLeg object specifies a single leg of the journey from 
 * the origin to the destination in the calculated route. For routes that 
 * contain no waypoints, the route will consist of a single "leg," 
 * but for routes that define one or more waypoints, the route will consist 
 * of one or more legs, corresponding to the specific legs of the journey.
 */
@interface TCDirectionsLeg : NSObject

/**
 * An array of TCDirectionsStep objects, each of which contains information 
 * about the individual steps in this leg.
 *
 * @see TCDirectionsStep
 */
@property (nonatomic, copy, readonly) NSArray *steps;

/**
 * The total distance covered by this leg. This property may be undefined as 
 * the distance may be unknown.
 */
@property (nonatomic, copy, readonly) TCDistance *distance;

/**
 * The total duration of this leg. This property may be undefined as the 
 * duration may be unknown.
 */
@property (nonatomic, copy, readonly) TCDuration *duration;

/**
 * Contains the latitude/longitude coordinates of the origin of this leg. 
 * Because Google Directions API calculates directions between locations 
 * by using the nearest transportation option (usually a road) at the start 
 * and end points, startLocation may be different than the provided origin of 
 * this leg if, for example, a road is not near the origin.
 */
@property (nonatomic, assign, readonly) CLLocationCoordinate2D startLocation;

/**
 * The address of the origin of this leg.
 */
@property (nonatomic, copy, readonly) NSString *startAddress;

/**
 * Contains the latitude/longitude coordinates of the given destination of 
 * this leg. Because Google Directions API calculates directions between 
 * locations by using the nearest transportation option (usually a road) at the
 * start and end points, endLocation may be different than the provided 
 * destination of this leg if, for example, a road is not near the destination.
 */
@property (nonatomic, assign, readonly) CLLocationCoordinate2D endLocation;

/**
 * The address of the destination of this leg.
 */
@property (nonatomic, copy, readonly) NSString *endAddress;

/**
 * Initializes a newly allocated TCDirectionsLeg object with results
 * returned from TCDirectionsService.
 * You don't instantiate this class directly; use TCDirectionsService to
 * obtain an instance.
 */
- (id)initWithProperties:(NSDictionary *)properties;

@end
