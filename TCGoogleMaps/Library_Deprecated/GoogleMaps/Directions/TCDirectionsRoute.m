//
//  TCDirectionsRoute.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/24/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCDirectionsRoute.h"
#import "TCDirectionsLeg.h"

@implementation TCDirectionsRoute

- (id)initWithProperties:(NSDictionary *)properties
{
    self = [super init];
    if (self) {
        _summary = properties[@"summary"];
        _encodedOverviewPath = properties[@"overview_polyline"][@"points"];
        _bounds = [self coordinateBoundsFromProperties:properties[@"bounds"]];
        _legs = [self legsFromProperties:properties[@"legs"]];
    }
    return self;
}

- (GMSCoordinateBounds *)coordinateBoundsFromProperties:(NSDictionary *)response
{
    CLLocationCoordinate2D northEastCoordinate = CLLocationCoordinate2DMake([response[@"northeast"][@"lat"] doubleValue], [response[@"northeast"][@"lng"] doubleValue]);
    CLLocationCoordinate2D southWestCoordinate = CLLocationCoordinate2DMake([response[@"southwest"][@"lat"] doubleValue], [response[@"southwest"][@"lng"] doubleValue]);
    GMSCoordinateBounds *coordinateBounds = [[GMSCoordinateBounds alloc] initWithCoordinate:northEastCoordinate coordinate:southWestCoordinate];
    return coordinateBounds;
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
