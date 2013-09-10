//
//  TCPlace.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/9/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCPlace.h"
#import "TCGoogleMapsAPIDataMapper.h"

@implementation TCPlace

- (id)initWithProperties:(NSDictionary *)properties
{
    self = [super init];
    if (self) {
        _name = [properties[@"name"] copy];
        _location = [TCGoogleMapsAPIDataMapper coordinateFromProperties:properties[@"geometry"][@"location"]];
        _address = [properties[@"vicinity"] copy];
    }
    return self;
}

@end
