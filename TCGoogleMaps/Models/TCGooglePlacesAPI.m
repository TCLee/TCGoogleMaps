//
//  TCGooglePlacesAPI.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/20/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCGooglePlacesAPI.h"
#import "TCGoogleAPIKeys.h"
#import "TCGoogleMapsAPIClient.h"

#pragma mark - TCGooglePlacesAutocomplete

@interface TCGooglePlacesAutocomplete ()
@property (nonatomic, copy, readwrite) NSString *description;
@property (nonatomic, copy, readwrite) NSString *reference;
@end

@implementation TCGooglePlacesAutocomplete
@end

#pragma mark - TCGooglePlace

@interface TCGooglePlace ()
@property (nonatomic, copy, readwrite) NSString *ID;
@property (nonatomic, copy, readwrite) NSString *reference;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, assign, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readwrite) NSURL *iconURL;
@property (nonatomic, copy, readwrite) NSString *formattedAddress;
@property (nonatomic, copy, readwrite) NSString *vicinity;
@property (nonatomic, copy, readwrite) NSString *internationalPhoneNumber;

@end

@implementation TCGooglePlace
@end

#pragma mark - TCGooglePlacesAPI

@interface TCGooglePlacesAPI ()

// Keep strong references to the HTTP Request operations, so that we can cancel them later.
@property (nonatomic, strong) AFHTTPRequestOperation *placesAutocompleteRequestOperation;
@property (nonatomic, strong) AFHTTPRequestOperation *placeDetailsRequestOperation;

@end

@implementation TCGooglePlacesAPI

+ (TCGooglePlacesAPI *)sharedAPI
{
    static TCGooglePlacesAPI *_sharedAPI = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAPI = [[TCGooglePlacesAPI alloc] init];
    });
    
    return _sharedAPI;
}

#pragma mark Places Autocomplete Service

- (void)placesAutocompleteForInput:(NSString *)input
                          location:(CLLocationCoordinate2D)coordinate
                            radius:(CLLocationDistance)radius
                        completion:(void (^)(NSArray *results, NSError *error))completion
{
    // Cancel any existing HTTP request operation before we begin a new one.
    [self.placesAutocompleteRequestOperation cancel];
    
    NSDictionary *parameters = @{@"input": input,
                                 @"sensor": @"false",
                                 @"key": kTCGooglePlacesAPIKey,
                                 @"location": [NSString stringWithFormat:@"%f,%f", coordinate.latitude, coordinate.longitude],
                                 @"radius": @(radius),
                                 @"types": @"establishment"};
    
    self.placesAutocompleteRequestOperation = [[TCGoogleMapsAPIClient sharedClient] getPath:@"place/autocomplete/json" parameters:parameters completion:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        if (responseObject) {
            completion(placesAutocompleteResultsFromJSONObject(responseObject), nil);
        } else {
            completion(nil, error);
        }
    }];
}

/*
 Maps the JSON response to an array of TCGooglePlacesAutocomplete objects.
 */
NSArray* placesAutocompleteResultsFromJSONObject(id JSONObject)
{
    NSArray *predictions = JSONObject[@"predictions"];
    NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:[predictions count]];
    
    for (NSDictionary *prediction in predictions) {
        TCGooglePlacesAutocomplete *placeAutocomplete = [[TCGooglePlacesAutocomplete alloc] init];
        placeAutocomplete.description = prediction[@"description"];
        placeAutocomplete.reference = prediction[@"reference"];
        [results addObject:placeAutocomplete];
    }
    
    return [results copy];
}

#pragma mark Place Details Service

- (void)placeDetailsWithReference:(NSString *)reference
                       completion:(void (^)(TCGooglePlace *placeDetails, NSError *error))completion
{
    // Cancel any existing HTTP request operation before we begin a new one.
    [self.placeDetailsRequestOperation cancel];
    
    NSDictionary *parameters = @{@"reference": reference,
                                 @"sensor": @"false",
                                 @"key": kTCGooglePlacesAPIKey};
    
    self.placeDetailsRequestOperation = [[TCGoogleMapsAPIClient sharedClient] getPath:@"place/details/json" parameters:parameters completion:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        if (responseObject) {
            completion(placeFromJSONObject(responseObject[@"result"]), nil);
        } else {
            completion(nil, error);
        }
    }];
}

/*
 Maps the JSON response to a TCGooglePlace object.
 */
TCGooglePlace* placeFromJSONObject(id JSONObject)
{
    TCGooglePlace *place = [[TCGooglePlace alloc] init];
    place.ID = JSONObject[@"id"];
    place.reference = JSONObject[@"reference"];
    place.name = JSONObject[@"name"];
    place.iconURL = [NSURL URLWithString:JSONObject[@"icon"]];
    place.formattedAddress = JSONObject[@"formatted_address"];
    place.vicinity = JSONObject[@"vicinity"];
    place.internationalPhoneNumber = JSONObject[@"international_phone_number"];
    
    id location = JSONObject[@"geometry"][@"location"];
    place.coordinate = CLLocationCoordinate2DMake([location[@"lat"] doubleValue],
                                                  [location[@"lng"] doubleValue]);
    
    return place;
}

@end