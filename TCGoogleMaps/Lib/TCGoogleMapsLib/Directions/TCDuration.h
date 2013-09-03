//
//  TCDuration.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/25/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 * A representation of duration as a numeric value and a display string.
 */
@interface TCDuration : NSObject

/**
 * A string representation of the duration value.
 */
@property (nonatomic, copy, readonly) NSString *text;

/**
 * The duration in seconds.
 */
@property (nonatomic, assign, readonly) NSTimeInterval value;

/**
 * Initializes a newly allocated TCDuration object with results
 * returned from TCDirectionsService.
 * You don't instantiate this class directly; use TCDirectionsService to
 * obtain an instance.
 */
- (id)initWithProperties:(NSDictionary *)properties;

@end
