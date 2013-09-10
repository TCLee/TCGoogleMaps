//
//  TCPlacesAutocompletePrediction.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/4/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A place prediction object returned by Google Places Autocomplete API.
 */
@interface TCPlacesAutocompletePrediction : NSObject

/**
 * Contains the human-readable name for the returned result.
 */
@property (nonatomic, copy, readonly) NSString *description;

/**
 * A reference that can be used to retrieve details about this place 
 * using the place details service.
 */
@property (nonatomic, copy, readonly) NSString *reference;

@end
