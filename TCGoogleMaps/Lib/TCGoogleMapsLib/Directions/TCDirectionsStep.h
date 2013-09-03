//
//  TCDirectionsStep.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/24/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

@class TCDistance;
@class TCDuration;

/**
 * A TCDirectionsStep is the most atomic unit of a direction's route, containing 
 * a single step describing a specific, single instruction on the journey. 
 * E.g. "Turn left at W. 4th St."
 */
@interface TCDirectionsStep : NSObject

/**
 * The distance covered by this step. This property may be nil as the 
 * distance may be unknown.
 */
@property (nonatomic, copy, readonly) TCDistance *distance;

/**
 * The total duration of this leg. This property may be nil as the
 * duration may be unknown.
 */
@property (nonatomic, copy, readonly) TCDuration *duration;

/**
 * The starting location of this step.
 */
@property (nonatomic, assign, readonly) CLLocationCoordinate2D startLocation;

/**
 * The ending location of this step.
 */
@property (nonatomic, assign, readonly) CLLocationCoordinate2D endLocation;

/**
 * Instructions for this step in plain text format.
 */
@property (nonatomic, copy, readonly) NSString *instructions;

/**
 * A GMSPath describing the course of this step. 
 * GMSPath is a class defined in the Google Maps iOS SDK.
 */
@property (nonatomic, copy, readonly) GMSPath *path;

/**
 * Initializes a newly allocated TCDirectionsStep object with results
 * returned from TCDirectionsService.
 * You don't instantiate this class directly; use TCDirectionsService to
 * obtain an instance.
 *
 * @return An initialized TCDirectionsStep object with the given properties.
 *         On error, returns nil.
 */
- (id)initWithProperties:(NSDictionary *)properties;

@end
