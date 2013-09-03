//
//  TCDirectionsRoute.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/24/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

/**
 * A single route containing a set of legs.
 */
@interface TCDirectionsRoute : NSObject

/*
 Contains a short textual description for the route, suitable for naming and
 disambiguating the route from alternatives.
 */
@property (nonatomic, copy, readonly) NSString *summary;

/**
 * Contains the viewport bounding box of this route.
 */
@property (nonatomic, strong, readonly) GMSCoordinateBounds *bounds;

/**
 * An array of TCDirectionsLeg objects, each of which contains information 
 * about the steps of which it is composed. There will be one leg for each 
 * waypoint or destination specified. So a route with no waypoints will 
 * contain one TCDirectionsLeg and a route with one waypoint will contain two.
 */
@property (nonatomic, copy, readonly) NSArray *legs;

/**
 * An array of CLLocationCooordinate2D structs that represent an approximate 
 * (smoothed) path of the resulting directions.
 */
@property (nonatomic, copy, readonly) GMSPath *overviewPath;

/**
 * Initializes a newly allocated TCDirectionsRoute object with results
 * returned from TCDirectionsService.
 * You don't instantiate this class directly; use TCDirectionsService to 
 * obtain an instance.
 */
- (id)initWithProperties:(NSDictionary *)properties;

@end
