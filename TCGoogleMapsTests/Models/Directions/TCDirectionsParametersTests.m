//
//  TCDirectionsParametersTests.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/30/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <CoreLocation/CLLocation.h>

#import "TCDirectionsParametersTests.h"
#import "TCDirectionsParameters.h"

@implementation TCDirectionsParametersTests

- (void)setUp
{
    self.parameters = [[TCDirectionsParameters alloc] init];
    self.parameters.origin = CLLocationCoordinate2DMake(10, 10);
    self.parameters.destination = CLLocationCoordinate2DMake(20, 20);
}

- (void)tearDown
{
    self.parameters = nil;
}

- (void)testOriginIsInitializedToInvalidCoordinate
{
    TCDirectionsParameters *myParameters = [[TCDirectionsParameters alloc] init];
    STAssertFalse(CLLocationCoordinate2DIsValid(myParameters.origin),
                  @"By default, origin coordinate is initialized to kCLLocationCoordinate2DInvalid.");
}

- (void)testDestinationIsInitializedToInvalidCoordinate
{
    TCDirectionsParameters *myParameters = [[TCDirectionsParameters alloc] init];
    STAssertFalse(CLLocationCoordinate2DIsValid(myParameters.destination),
                  @"By default, destination coordinate is initialized to kCLLocationCoordinate2DInvalid.");
}

- (void)testAssertFailIfOriginIsInvalid
{
    self.parameters.origin = kCLLocationCoordinate2DInvalid;
    STAssertThrows([self.parameters dictionary],
                   @"Assert should fail if origin is invalid.");
}

- (void)testAssertFailIfDestinationIsInvalid
{
    self.parameters.destination = kCLLocationCoordinate2DInvalid;
    STAssertThrows([self.parameters dictionary],
                   @"Assert should fail if destination is invalid.");
}

- (void)testAvoidTolls
{
    self.parameters.avoidTolls = YES;
    
    NSDictionary *parametersDictionary = [self.parameters dictionary];
    STAssertEqualObjects(parametersDictionary[@"avoid"], @"tolls", @"'avoid' parameter should be set to 'tolls'.");
}

- (void)testAvoidHighways
{
    self.parameters.avoidHighways = YES;
    
    NSDictionary *parametersDictionary = [self.parameters dictionary];
    STAssertEqualObjects(parametersDictionary[@"avoid"], @"highways", @"'avoid' parameter should be set to 'highways'.");    
}

- (void)testAvoidTollsAndHighways
{
    self.parameters.avoidHighways = YES;
    self.parameters.avoidTolls = YES;
    
    NSDictionary *parametersDictionary = [self.parameters dictionary];
    STAssertEqualObjects(parametersDictionary[@"avoid"], @"tolls|highways", @"'avoid' parameter should be set to 'tolls|highways'.");
}

@end
