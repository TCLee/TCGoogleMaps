//
//  TCPlacesAutocompleteService.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/9/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCPlacesAutocompleteService.h"
#import "TCPlacesAutocompleteParameters.h"
#import "TCPlacesAutocompletePrediction.h"
#import "TCPlacesAutocompletePredictionPrivate.h"
#import "TCPlacesServiceStatusConstants.h"
#import "TCPlacesServiceError.h"
#import "TCGoogleMapsAPIClient.h"
#import "TCGoogleMapsAPIDataMapper.h"

@interface TCPlacesAutocompleteService ()

@property (nonatomic, strong) TCGoogleMapsAPIClient *APIClient;
@property (nonatomic, assign) BOOL sensor;
@property (nonatomic, copy) NSString *key;

/**
 * Each request to the Google Places API is encapsulated in a `AFHTTPRequestOperation`.
 * The service object ensures that there is only one request at any one time.
 * The previous request will be cancelled before a new one can begin.
 */
@property (nonatomic, strong) AFHTTPRequestOperation *placesAutocompleteRequest;

@end

@implementation TCPlacesAutocompleteService

- (id)initWithAPIClient:(TCGoogleMapsAPIClient *)APIClient key:(NSString *)key sensor:(BOOL)sensor
{
    self = [super init];
    if (self) {
        _APIClient = APIClient;
        _key = [key copy];
        _sensor = sensor;
    }
    return self;
}

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
    
    self.placesAutocompleteRequest = [self.APIClient getPath:@"place/autocomplete/json"
                                                  parameters:DictionaryFromParameters(parameters, self.key, self.sensor)
                                                  completion:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        if (responseObject) {
            NSString *statusCode = responseObject[@"status"];
            
            // If Google Places API response's status is OK, then it means we
            // have a valid result to parse. Otherwise, we will report it as an error.
            if ([statusCode isEqualToString:TCPlacesServiceStatusOK]) {
                Callback(completion, AutocompletePredictionsFromResponse(responseObject), nil);
            } else {
                Callback(completion, nil, [TCPlacesServiceError errorWithStatusCode:statusCode]);
            }
        } else if (error) {
            Callback(completion, nil, error);
        }
    }];
}

/**
 * Invokes the `completion` block with the given parameters.
 * If `completion` block is nil, then nothing will happen.
 */
FOUNDATION_STATIC_INLINE void Callback(TCPlacesAutocompleteServiceCallback completion, NSArray *predictions, NSError *error)
{
    if (completion) {
        completion(predictions, error);
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

/**
 * Returns a dictionary representation of the parameters,
 * and includes the API key and sensor parameters too.
 */
static NSDictionary *DictionaryFromParameters(TCPlacesAutocompleteParameters *parameters, NSString *APIKey, BOOL sensor)
{
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];

    // Add the key and sensor parameters that are required for all
    // Google Places API requests.
    mutableDictionary[@"key"] = APIKey;
    mutableDictionary[@"sensor"] = [TCGoogleMapsAPIDataMapper stringFromBool:sensor];

    // Required parameter (search text).
    mutableDictionary[@"input"] = parameters.input;
    
    // Optional parameters for searching nearby a given location.
    if (CLLocationCoordinate2DIsValid(parameters.location)) {
        mutableDictionary[@"location"] = [TCGoogleMapsAPIDataMapper stringFromCoordinate:parameters.location];
    }
    if (parameters.radius > 0) {
        mutableDictionary[@"radius"] = [@(parameters.radius) stringValue];
    }
    
    return [mutableDictionary copy];
}

@end
