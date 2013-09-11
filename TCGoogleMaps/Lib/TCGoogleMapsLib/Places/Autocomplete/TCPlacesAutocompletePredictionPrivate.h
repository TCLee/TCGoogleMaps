//
//  TCPlacesAutocompletePredictionPrivate.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/11/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCPlacesAutocompletePrediction.h"

/**
 * Private interface to be used by classes in this "package" only.
 */
@interface TCPlacesAutocompletePrediction ()

/**
 * Initializes a newly allocated `TCPlacesAutocompletePrediction` object with
 * results returned from `TCPlacesService`.
 */
- (id)initWithProperties:(NSDictionary *)properties;

@end
