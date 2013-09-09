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
#import "TCPlacesServiceStatus.h"
#import "TCPlacesServiceError.h"
#import "TCGoogleMapsAPIClient.h"
#import "TCGoogleMapsAPIDataMapper.h"

@interface TCPlacesAutocompleteService ()

/**
 * The `TCGoogleMapsAPIClient` instance that will be used to send
 * HTTP requests to Google Maps APIs. This allows us to set a mock API
 * client that doesn't connect to the network for unit testing.
 */
@property (nonatomic, strong) TCGoogleMapsAPIClient *APIClient;

/**
 * The sensor parameter used for all Google Places API requests.
 */
@property (nonatomic, assign) BOOL sensor;

/**
 * The API key parameter used for all Google Places API requests.
 */
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
    NSParameterAssert(parameters);
    
    NSAssert([self.key length] > 0,
             @"You must provide the API key to use Google Places service. "
             "Call setAPIKey:sensor: to provide the required API key and sensor parameters.");
    
    // Cancel any existing request operation before we begin a new one.
    // We don't want to overwhelm Google's servers with too many requests at a time.
    [self.placesAutocompleteRequest cancel];
    
    self.placesAutocompleteRequest = [self.APIClient getPath:@"place/autocomplete/json"
                                                  parameters:[self dictionaryFromParameters:parameters]
                                                  completion:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        if (responseObject) {
            NSString *statusCode = responseObject[@"status"];
            
            // If Google Places API response's status is OK, then it means we
            // have a valid result to parse. Otherwise, we will report it as an error.
            if ([statusCode isEqualToString:TCPlacesServiceStatusOK]) {
                invokeCompletion(completion, [self predictionsFromResponse:responseObject[@"predictions"]], nil);
            } else {
                invokeCompletion(completion, nil, [TCPlacesServiceError errorWithStatusCode:statusCode]);
            }
        } else if (error) {
            invokeCompletion(completion, nil, error);
        }
    }];
}

/**
 * Invokes the `completion` block with the given parameters.
 * If `completion` block is nil, then nothing will happen.
 */
FOUNDATION_STATIC_INLINE void invokeCompletion(TCPlacesAutocompleteServiceCallback completion, NSArray *predictions, NSError *error)
{
    if (completion) {
        completion(predictions, error);
    }
}

/**
 * Returns an array of TCPlacesAutocompletePrediction objects from
 * the response data.
 */
- (NSArray *)predictionsFromResponse:(NSArray *)predictionsResponse
{
    NSMutableArray *predictions = [[NSMutableArray alloc] initWithCapacity:[predictionsResponse count]];
    for (NSDictionary *predictionResponse in predictionsResponse) {
        TCPlacesAutocompletePrediction *prediction = [[TCPlacesAutocompletePrediction alloc] initWithProperties:predictionResponse];
        [predictions addObject:prediction];
    }
    return [predictions copy];
}

/**
 * Returns a dictionary representation of the parameters.
 */
- (NSDictionary *)dictionaryFromParameters:(TCPlacesAutocompleteParameters *)parameters
{
    NSAssert([self.key length] > 0,
             @"You must provide an API key to use the Google Places APIs.");
    NSAssert([parameters.input length] > 0,
             @"Google Places Autocomplete API requires a non-empty input string.");
    
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    
    // Required parameters for Google Places Autocomplete API.
    mutableDictionary[@"key"] = self.key;
    mutableDictionary[@"sensor"] = [TCGoogleMapsAPIDataMapper stringFromBool:self.sensor];
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
