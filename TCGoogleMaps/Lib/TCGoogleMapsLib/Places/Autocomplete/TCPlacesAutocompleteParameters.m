//
//  TCPlacesAutocompleteParameters.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/3/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCPlacesAutocompleteParameters.h"
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
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    
    // Required parameter (search text).
    mutableDictionary[@"input"] = self.input;
        
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
