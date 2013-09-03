//
//  TCDirectionsLegTests.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/3/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCDirectionsLegTests.h"
#import "TCTestData.h"

#import "TCDirectionsLeg.h"
#import "TCDirectionsStep.h"
#import "TCDuration.h"
#import "TCDistance.h"

@implementation TCDirectionsLegTests

- (void)testInitWithValidProperties
{
    id serviceResponse = [TCTestData JSONObjectFromFilename:@"TCDirectionsServiceTests_OneRoute"];
    NSDictionary *legProperties = serviceResponse[@"routes"][0][@"legs"][0];
    TCDirectionsLeg *leg = [[TCDirectionsLeg alloc] initWithProperties:legProperties];

    STAssertEqualObjects(leg.startAddress, @"Chicago, IL, USA", @"Leg's start address should match test data value.");
    STAssertEqualObjects(leg.endAddress, @"St. Louis, MO, USA", @"Leg's end address should match test data value.");
    STAssertEquals(leg.startLocation, CLLocationCoordinate2DMake(41.8781139, -87.6297872), @"Leg's start location coordinate should match test data value.");
    STAssertEquals(leg.endLocation, CLLocationCoordinate2DMake(38.6276455, -90.1991661), @"Leg's end location coordinate should match test data value.");
    
    STAssertEquals(leg.distance.value, (CLLocationDistance)477662, @"Leg's distance object should match test data value.");
    STAssertEqualObjects(leg.distance.text, @"297 mi", @"Leg's distance object should match test data value.");
    
    STAssertEquals(leg.duration.value, (NSTimeInterval)15947, @"Leg's duration object should match test data value.");
    STAssertEqualObjects(leg.duration.text, @"4 hours 26 mins", @"Leg's duration object should match test data value.");
    
    STAssertEquals([leg.steps count], (NSUInteger)11, @"The number of steps in this leg should match test data value.");
    for (id step in leg.steps) {
        STAssertTrue([step isKindOfClass:[TCDirectionsStep class]],
                     @"Steps should be of class TCDirectionsStep.");
    }
}

- (void)testInitWithNilPropertiesShouldReturnNil
{
    TCDirectionsLeg *leg = [[TCDirectionsLeg alloc] initWithProperties:nil];
    STAssertNil(leg, @"Leg should be nil if given nil properties.");
}

@end
