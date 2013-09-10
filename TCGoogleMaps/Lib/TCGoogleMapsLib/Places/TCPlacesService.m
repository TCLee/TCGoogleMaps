//
//  TCPlacesService.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/3/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCPlacesService.h"
#import "TCPlacesAutocompleteService.h"
#import "TCPlaceDetailsService.h"

@interface TCPlacesService ()

/**
 * The service object to access Google Places Autocomplete API.
 */
@property (nonatomic, strong, readonly) TCPlacesAutocompleteService *autocompleteService;

/**
 * The service object to access Google Place Details API.
 */
@property (nonatomic, strong, readonly) TCPlaceDetailsService *placeDetailsService;

@end

@implementation TCPlacesService

@synthesize autocompleteService = _autocompleteService;
@synthesize placeDetailsService = _placeDetailsService;

+ (TCPlacesService *)sharedService
{
    static TCPlacesService *_sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedService = [[TCPlacesService alloc] init];
    });    
    return _sharedService;
}

#pragma mark - Places Autocomplete Service

- (TCPlacesAutocompleteService *)autocompleteService
{
    if (!_autocompleteService) {
        _autocompleteService = [[TCPlacesAutocompleteService alloc] init];
    }
    return _autocompleteService;
}

- (void)placePredictionsWithParameters:(TCPlacesAutocompleteParameters *)parameters completion:(TCPlacesAutocompleteServiceCallback)completion
{
    [self.autocompleteService placePredictionsWithParameters:parameters completion:completion];
}

#pragma mark - Place Details Service

- (TCPlaceDetailsService *)placeDetailsService
{
    if (!_placeDetailsService) {
        _placeDetailsService = [[TCPlaceDetailsService alloc] init];
    }
    return _placeDetailsService;
}

- (void)placeDetailsWithReference:(NSString *)reference completion:(TCPlaceDetailsServiceCallback)completion
{    
    [self.placeDetailsService placeDetailsWithReference:reference completion:completion];
}

@end
