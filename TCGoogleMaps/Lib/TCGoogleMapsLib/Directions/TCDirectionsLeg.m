//
//  TCDirectionsLeg.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/24/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCDirectionsLeg.h"
#import "TCDirectionsStep.h"
#import "TCDistance.h"
#import "TCDuration.h"
#import "TCGoogleMapsAPIDataMapper.h"

@implementation TCDirectionsLeg

- (id)initWithProperties:(NSDictionary *)properties
{
    if (!properties) { return nil; }
    
    self = [super init];
    if (self) {
        _steps = [self stepsFromProperties:properties[@"steps"]];
        _distance = [[TCDistance alloc] initWithProperties:properties[@"distance"]];
        _duration = [[TCDuration alloc] initWithProperties:properties[@"duration"]];
        _startLocation = [TCGoogleMapsAPIDataMapper coordinateFromProperties:properties[@"start_location"]];
        _startAddress = properties[@"start_address"];
        _endLocation = [TCGoogleMapsAPIDataMapper coordinateFromProperties:properties[@"end_location"]];
        _endAddress = properties[@"end_address"];
    }
    return self;
}

- (NSArray *)stepsFromProperties:(NSArray *)properties
{
    NSMutableArray *steps = [[NSMutableArray alloc] initWithCapacity:[properties count]];
    
    for (NSDictionary *stepProperties in properties) {
        TCDirectionsStep *step = [[TCDirectionsStep alloc] initWithProperties:stepProperties];
        [steps addObject:step];
    }
    return steps;
}

@end
