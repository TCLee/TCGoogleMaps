//
//  TCPlacesAutocompleteParameters_Private.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/7/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCPlacesAutocompleteParameters.h"

/**
 * "Private" properties that should only be used by the classes in
 * the Google Places API Library package.
 */
@interface TCPlacesAutocompleteParameters ()

@property (nonatomic, assign, readwrite) BOOL sensor;
@property (nonatomic, copy, readwrite) NSString *key;

@end
