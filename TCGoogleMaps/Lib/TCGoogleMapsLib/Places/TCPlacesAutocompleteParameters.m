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
    
    NSAssert(nil != self.input && [self.input length] > 0,
             @"Input is a required parameter. "
             "It cannot be nil or an empty string.");
    
    mutableDictionary[@"input"] = self.input;
    
    if (CLLocationCoordinate2DIsValid(self.location)) {
        mutableDictionary[@"location"] = [TCGoogleMapsAPIDataMapper stringFromCoordinate:self.location];
    }
    
    if (self.radius > 0) {
        mutableDictionary[@"radius"] = [@(self.radius) stringValue];
    }
    
    return [mutableDictionary copy];
}

@end
