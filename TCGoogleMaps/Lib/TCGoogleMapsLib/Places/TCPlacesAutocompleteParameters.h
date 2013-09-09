//
//  TCPlacesAutocompleteParameters.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/3/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

/**
 * The request parameters to be sent to Google Places Autocomplete API.
 */
@interface TCPlacesAutocompleteParameters : NSObject

/**
 * The text string on which to search. The Place API will return candidate 
 * matches based on this string and order results based on their perceived 
 * relevance. Required.
 */
@property (nonatomic, copy) NSString *input;

/**
 * Location for prediction biasing. Predictions will be biased towards 
 * the given `location` and `radius`. Optional.
 */
@property (nonatomic, assign) CLLocationCoordinate2D location;

/**
 * The radius of the area used for prediction biasing. The radius is 
 * specified in meters, and must always be accompanied by a 
 * `location` property. Optional.
 */
@property (nonatomic, assign) CLLocationDistance radius;

@end
