//
//  TCDistanceTests.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/31/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCDistanceTests.h"
#import "TCDistance.h"
#import <CoreLocation/CLLocation.h>

@implementation TCDistanceTests

- (void)testInitWithValidProperties
{
    CLLocationDistance const value = 10000.0f;
    NSString * const text = @"10 km";
    NSDictionary *distanceProperties = @{@"value": @(value), @"text": text};
    
    TCDistance *distance = [[TCDistance alloc] initWithProperties:distanceProperties];
    STAssertEquals(distance.value, value, @"TCDistance value property is set to an incorrect value.");
    STAssertEqualObjects(distance.text, text, @"TCDistance text property is set to an incorrect value.");
}

- (void)testInitWithNilShouldReturnNil
{
    TCDistance *distance = [[TCDistance alloc] initWithProperties:nil];
    STAssertNil(distance, @"TCDistance init with nil should also return nil.");
}

@end
