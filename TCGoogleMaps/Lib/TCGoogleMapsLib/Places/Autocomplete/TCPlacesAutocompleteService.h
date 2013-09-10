//
//  TCPlacesAutocompleteService.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/9/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TCPlacesServiceBlocks.h"

@class TCGoogleMapsAPIClient;
@class TCPlacesAutocompleteParameters;

/**
 * Service class to simplify access to the Google Places Autocomplete API.
 */
@interface TCPlacesAutocompleteService : NSObject

/**
 * Returns an initialized `TCPlacesAutocompleteService` instance.
 *
 * @param APIClient the API client object used to send the HTTP requests
 * @param key       the API key parameter
 * @param sensor    the sensor parameter
 */
- (id)initWithAPIClient:(TCGoogleMapsAPIClient *)APIClient key:(NSString *)key sensor:(BOOL)sensor;

- (void)placePredictionsWithParameters:(TCPlacesAutocompleteParameters *)parameters completion:(TCPlacesAutocompleteServiceCallback)completion;

@end
