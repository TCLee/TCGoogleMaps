//
//  TCPlacesAutocompleteParametersTests.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/5/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCPlacesAutocompleteParametersTests.h"
#import "TCPlacesAutocompleteParameters.h"
#import "TCPlacesAutocompleteParametersPrivate.h"

#import <CoreLocation/CLLocation.h>

@implementation TCPlacesAutocompleteParametersTests

- (void)setUp
{
    self.parameters = [[TCPlacesAutocompleteParameters alloc] init];
    self.parameters.key = @"FAKE-API-KEY";
    self.parameters.sensor = YES;
    self.parameters.input = @"Hello World!";
}

- (void)tearDown
{
    self.parameters = nil;
}

- (void)testWithAllParameters
{
    self.parameters.key = @"FAKE-API-KEY";
    self.parameters.sensor = YES;
    self.parameters.input = @"Whatever";
    self.parameters.location = CLLocationCoordinate2DMake(10.25, 20.25);
    self.parameters.radius = (CLLocationDistance)500;
    
    NSDictionary *dictionary = [self.parameters dictionary];
    
    STAssertEqualObjects(dictionary[@"key"], self.parameters.key,
                         @"Dictionary value for key \"key\" should match the parameter's key property.");
    STAssertEqualObjects(dictionary[@"sensor"], @"true",
                         @"Dictionary value for key \"sensor\" should be \"true\" (string equivalent of YES).");
    STAssertEqualObjects(dictionary[@"input"], self.parameters.input,
                         @"Dictionary value for key \"input\" should match the parameter's input property.");
    STAssertEqualObjects(dictionary[@"location"], @"10.25,20.25",
                         @"Dictionary's \"location\" key's string value was not converted properly from a CLLocationCoordinate2D.");
    STAssertEqualObjects(dictionary[@"radius"], @"500",
                         @"Dictionary's \"radius\" key's string value was not converted properly from a CLLocationDistance.");
}

- (void)testParametersWithNoLocationBiasing
{
    NSDictionary *dictionary = [self.parameters dictionary];
    
    STAssertNotNil(dictionary[@"key"], @"There should be a \"key\" key.");
    STAssertNotNil(dictionary[@"sensor"], @"There should be a \"sensor\" key.");
    STAssertNotNil(dictionary[@"input"], @"There should be an \"input\" key.");
    STAssertNil(dictionary[@"location"], @"There should be no \"location\" key, if no location is given.");
    STAssertNil(dictionary[@"radius"], @"There should be no \"radius\" key, if no location is given.");
}

- (void)testParametersWithNilInputShouldThrowException
{
    self.parameters.input = nil;
    
    STAssertThrows([self.parameters dictionary],
                   @"If required parameter \"input\" is nil, it should be caught by an NSAssert.");
}

- (void)testParametersWithEmptyInputShouldThrowException
{
    self.parameters.input = @"";
    
    STAssertThrows([self.parameters dictionary],
                   @"If \"input\" parameter is an empty string, it should be caught by an NSAssert.");
}

- (void)testLocationIsInitializedToInvalidCoordinates
{
    // Create an empty parameters object.
    self.parameters = [[TCPlacesAutocompleteParameters alloc] init];
    
    STAssertFalse(CLLocationCoordinate2DIsValid(self.parameters.location),
                  @"location property should be initialized to kCLLocationCoordinate2DInvalid");
}

@end
