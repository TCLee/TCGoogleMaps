//
//  TCPlacesService.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/3/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCGoogleMapsAPIClient;
@class TCPlacesAutocompleteParameters;

/**
 * Callback block for when Google Places Autocomplete API has returned the results.
 *
 * @param predictions the array of `TCPlacesAutocompletePrediction` objects representing the autocomplete results
 * @param error a `NSError` object describing why the service request failed
 */
typedef void (^TCPlacesAutocompleteServiceCallback)(NSArray *predictions, NSError *error);

/**
 * Provides methods to access the Google Places API.
 */
@interface TCPlacesService : NSObject

/**
 * A custom `TCGoogleMapsAPIClient` instance that will be used to send
 * HTTP requests to Google Maps APIs.
 * If this property is nil, then the default `TCGoogleMapsAPIClient`
 * shared instance will be used.
 */
@property (nonatomic, strong) TCGoogleMapsAPIClient *APIClient;

/**
 * Returns a shared `TCPlacesService` instance to access Google Placess API.
 */
+ (TCPlacesService *)sharedService;

/**
 * Retrieves place autocomplete predictions based on the supplied 
 * autocomplete request parameters.
 *
 * @param parameters the autocomplete request parameters. Cannot be nil.
 * @param completion the block to execute when autocomplete prediction results are returned.
 */
- (void)placePredictionsWithParameters:(TCPlacesAutocompleteParameters *)parameters completion:(TCPlacesAutocompleteServiceCallback)completion;

@end
