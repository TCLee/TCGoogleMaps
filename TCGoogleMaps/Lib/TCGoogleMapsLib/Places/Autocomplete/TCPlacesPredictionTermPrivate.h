//
//  TCPlacesPredictionTermPrivate.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/11/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCPlacesPredictionTerm.h"

/**
 * Private interface to be used by classes in this "package" only.
 */
@interface TCPlacesPredictionTerm ()

/**
 * Initializes and returns a `TCPlacesPredictionTerm` instance with
 * the values from the given dictionary.
 *
 * @param properties a dictionary containing the term's property values
 */
- (id)initWithProperties:(NSDictionary *)properties;

@end
