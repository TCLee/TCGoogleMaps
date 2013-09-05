//
//  TCPlacesService.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/3/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCPlacesService.h"
#import "TCPlacesServiceError.h"
#import "TCPlacesServiceStatus.h"
#import "TCPlacesAutocompleteParameters.h"
#import "TCPlacesAutocompletePrediction.h"
#import "TCGoogleMapsAPIClient.h"

@interface TCPlacesService ()

// Keep a strong reference to the request operation, so that we can cancel it later.
@property (nonatomic, strong) AFHTTPRequestOperation *requestOperation;

@end

@implementation TCPlacesService

+ (TCPlacesService *)sharedService
{
    static TCPlacesService *_sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedService = [[TCPlacesService alloc] init];
    });    
    return _sharedService;
}

- (void)placePredictionsWithParameters:(TCPlacesAutocompleteParameters *)parameters
                            completion:(TCPlacesAutocompleteServiceCallback)completion
{
    NSParameterAssert(parameters);
    NSParameterAssert(completion);
    
    // Use the default shared API client, if no custom API client is given.
    TCGoogleMapsAPIClient *client = self.APIClient ? self.APIClient : [TCGoogleMapsAPIClient sharedClient];
    
    // Cancel any existing request operation before we begin a new one.
    [self.requestOperation cancel];
    
    self.requestOperation = [client getPath:@"place/autocomplete/json" parameters:[parameters dictionary] completion:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        // If response is nil, it means an error has occured at the AFNetworking level.
        if (!responseObject) {
            completion(nil, error);
        }
        
        NSString *statusCode = responseObject[@"status"];

        // If Google Places API response's status is OK, then it means we
        // have a valid result to parse.
        // Otherwise, we will report it as an error.
        if ([statusCode isEqualToString:TCPlacesServiceStatusOK]) {
            completion([self predictionsFromResponse:responseObject[@"predictions"]], nil);
        } else {
            completion(nil, [TCPlacesServiceError errorWithStatusCode:statusCode]);
        }
    }];
}

// Returns an array of TCPlacesAutocompletePrediction objects from
// the response data.
- (NSArray *)predictionsFromResponse:(NSArray *)predictionsResponse
{
    NSMutableArray *predictions = [[NSMutableArray alloc] initWithCapacity:[predictionsResponse count]];
    for (NSDictionary *predictionResponse in predictionsResponse) {
        TCPlacesAutocompletePrediction *prediction = [[TCPlacesAutocompletePrediction alloc] initWithProperties:predictionResponse];
        [predictions addObject:prediction];
    }
    return [predictions copy];
}

@end
