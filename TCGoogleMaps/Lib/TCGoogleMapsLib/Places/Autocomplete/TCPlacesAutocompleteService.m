//
//  TCPlacesAutocompleteService.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/9/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCPlacesAutocompleteService.h"
#import "TCPlacesAutocompleteParameters.h"
#import "TCPlacesAutocompleteParametersPrivate.h"
#import "TCPlacesAutocompletePrediction.h"
#import "TCPlacesAutocompletePredictionPrivate.h"
#import "TCPlacesServiceStatusCode.h"
#import "TCPlacesServiceError.h"
#import "TCGooglePlacesAPIClient.h"
#import "TCGoogleMapsAPIDataMapper.h"

@interface TCPlacesAutocompleteService ()

/**
 * Each request to the Google Places API is encapsulated in a `AFHTTPRequestOperation`.
 * The service object ensures that there is only one request at any one time.
 * The previous request will be cancelled before a new one can begin.
 */
@property (nonatomic, strong) AFHTTPRequestOperation *placesAutocompleteRequest;

@end

@implementation TCPlacesAutocompleteService

- (void)placePredictionsWithParameters:(TCPlacesAutocompleteParameters *)parameters
                            completion:(TCPlacesAutocompleteServiceCallback)completion
{
    NSAssert(nil != parameters,
             @"Parameters are required to send a request to Google Places Autocomplete API.");
    NSAssert([parameters.input length] > 0,
             @"Google Places Autocomplete API requires a non-empty input string.");
    
    // Cancel any existing request operation before we begin a new one.
    // We don't want to overwhelm Google's servers with too many requests at a time.
    [self.placesAutocompleteRequest cancel];
    
    self.placesAutocompleteRequest = [[TCGooglePlacesAPIClient defaultClient] getPath:@"autocomplete/json" parameters:[parameters dictionary] completion:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        if (responseObject) {
            ParseResponse(responseObject, completion);
        } else if (error) {
            Callback(completion, nil, error);
        }
    }];
}

FOUNDATION_STATIC_INLINE void Callback(TCPlacesAutocompleteServiceCallback completion, NSArray *predictions, NSError *error)
{
    if (completion) {
        completion(predictions, error);
    }
}

static void ParseResponse(NSDictionary *response, TCPlacesAutocompleteServiceCallback completion)
{
    NSString *statusCode = response[@"status"];    
    if ([statusCode isEqualToString:TCPlacesServiceStatusOK]) {
        Callback(completion, AutocompletePredictionsFromResponse(response), nil);
    } else {
        Callback(completion, nil, [TCPlacesServiceError errorWithStatusCode:statusCode]);
    }
}

/**
 * Returns an array of TCPlacesAutocompletePrediction objects from
 * the response data.
 */
static NSArray *AutocompletePredictionsFromResponse(NSDictionary *response)
{
    NSArray *predictionsResponse = response[@"predictions"];
    NSMutableArray *predictions = [[NSMutableArray alloc] initWithCapacity:[predictionsResponse count]];
    
    for (NSDictionary *predictionResponse in predictionsResponse) {
        TCPlacesAutocompletePrediction *prediction = [[TCPlacesAutocompletePrediction alloc] initWithProperties:predictionResponse];
        [predictions addObject:prediction];
    }
    return [predictions copy];
}

@end
