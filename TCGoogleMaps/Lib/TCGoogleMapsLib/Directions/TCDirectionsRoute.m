//
//  TCDirectionsRoute.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/24/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCDirectionsRoute.h"
#import "TCDirectionsLeg.h"
#import "TCGoogleMapsAPIDataMapper.h"

@implementation TCDirectionsRoute

- (id)initWithProperties:(NSDictionary *)properties
{
    if (!properties) { return nil; }
    
    self = [super init];
    if (self) {
        _summary = properties[@"summary"];
        _overviewPath = [GMSPath pathFromEncodedPath:properties[@"overview_polyline"][@"points"]];
        _bounds = [TCGoogleMapsAPIDataMapper coordinateBoundsFromProperties:properties[@"bounds"]];
        _legs = [self legsFromProperties:properties[@"legs"]];
    }
    return self;
}

- (NSArray *)legsFromProperties:(NSArray *)properties
{
    NSMutableArray *legs = [[NSMutableArray alloc] initWithCapacity:[properties count]];
    
    for (NSDictionary *legProperties in properties) {
        TCDirectionsLeg *leg = [[TCDirectionsLeg alloc] initWithProperties:legProperties];
        [legs addObject:leg];
    }    
    return [legs copy];
}

@end
