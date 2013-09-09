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

@end
