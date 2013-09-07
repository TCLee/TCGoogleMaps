//
//  TCPlacesAutocompleteParameters.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/3/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCPlacesAutocompleteParameters.h"
#import "TCPlacesAutocompleteParametersPrivate.h"
#import "TCGoogleMapsAPIDataMapper.h"

@implementation TCPlacesAutocompleteParameters

- (id)init
{
    self = [super init];
    if (self) {        
        _location = kCLLocationCoordinate2DInvalid;
        _radius = (CLLocationDistance)0;
    }
    return self;
}

- (NSDictionary *)dictionary
{
    NSAssert([self.key length] > 0,
             @"You must provide an API key to use the Google Places APIs.");
    NSAssert([self.input length] > 0,
             @"Google Places Autocomplete API requires a non-empty input string.");

    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    
    // Required parameters for Google Places Autocomplete API.
    mutableDictionary[@"input"] = self.input;
    mutableDictionary[@"key"] = self.key;
    mutableDictionary[@"sensor"] = [TCGoogleMapsAPIDataMapper stringFromBool:self.sensor];
    
    // Optional parameters for searching nearby a given location.
    if (CLLocationCoordinate2DIsValid(self.location)) {
        mutableDictionary[@"location"] = [TCGoogleMapsAPIDataMapper stringFromCoordinate:self.location];
    }
    if (self.radius > 0) {
        mutableDictionary[@"radius"] = [@(self.radius) stringValue];
    }
    
    return [mutableDictionary copy];
}

@end
