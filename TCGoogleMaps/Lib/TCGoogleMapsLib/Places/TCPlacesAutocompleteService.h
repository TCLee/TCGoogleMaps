//
//  TCPlacesAutocompleteService.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/9/13.
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
 * Service class to simplify access to the Google Places Autocomplete API.
 */
@interface TCPlacesAutocompleteService : NSObject

/**
 * <#Description#>
 *
 * @param APIClient <#APIClient description#>
 * @param key       <#key description#>
 * @param sensor    <#sensor description#>
 *
 * @return <#return value description#>
 */
- (id)initWithAPIClient:(TCGoogleMapsAPIClient *)APIClient key:(NSString *)key sensor:(BOOL)sensor;

/**
 * Retrieves place autocomplete predictions based on the supplied
 * autocomplete request parameters.
 *
 * @param parameters the autocomplete request parameters. Cannot be nil.
 * @param completion the block to execute when autocomplete prediction results are returned.
 *                   Pass in nil, if you don't need to be notified of completion.
 */
- (void)placePredictionsWithParameters:(TCPlacesAutocompleteParameters *)parameters completion:(TCPlacesAutocompleteServiceCallback)completion;

@end
