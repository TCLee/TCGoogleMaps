//
//  TCDirectionsStep.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/24/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

@class TCDistance;
@class TCDuration;

@interface TCDirectionsStep : NSObject

/**
 * The distance covered by this step. This property may be undefined as the distance may be unknown.
 */
@property (nonatomic, copy, readonly) TCDistance *distance;

/**
 * The total duration of this leg. This property may be undefined as the
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
 * Instructions for this step with style attributes taken from the HTML string.
 */
@property (nonatomic, copy, readonly) NSAttributedString *attributedInstructions;

/**
 * Instructions for this step in plain text format.
 */
@property (nonatomic, copy, readonly) NSString *instructions;

/**
 * An encoded sequence of coordinates describing the course of this step.
 */
@property (nonatomic, copy, readonly) NSString *encodedPath;

/**
 * Initializes a newly allocated TCDirectionsStep object with results
 * returned from TCDirectionsService.
 * You don't instantiate this class directly; use TCDirectionsService to
 * obtain an instance.
 */
- (id)initWithProperties:(NSDictionary *)properties;

@end
