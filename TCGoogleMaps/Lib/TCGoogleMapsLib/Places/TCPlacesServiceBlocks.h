//
//  TCPlacesServiceBlocks.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/10/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

@class TCPlace;

/**
 * Callback block for when Google Places Autocomplete service has returned
 * the results.
 *
 * @param predictions the array of `TCPlacesAutocompletePrediction` objects representing the autocomplete results
 * @param error a `NSError` object describing why the service request failed
 */
typedef void (^TCPlacesAutocompleteServiceCallback)(NSArray *predictions, NSError *error);

/**
 * The block that will be called when Google Place Details service has
 * returned with a result or an error has occured.
 *
 * @param place the place result returned by the Place Details service. On error, it will be nil.
 * @param error on error, it will contain the NSError object describing why the request failed
 */
typedef void (^TCPlaceDetailsServiceCallback) (TCPlace *place, NSError *error);