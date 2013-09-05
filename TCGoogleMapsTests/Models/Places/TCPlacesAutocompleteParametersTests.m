//
//  TCPlacesAutocompleteParametersTests.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/5/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCPlacesAutocompleteParametersTests.h"
#import "TCPlacesAutocompleteParameters.h"

#import <CoreLocation/CLLocation.h>

@implementation TCPlacesAutocompleteParametersTests

- (void)setUp
{
    self.parameters = [[TCPlacesAutocompleteParameters alloc] init];
}

- (void)tearDown
{
    self.parameters = nil;
}

- (void)testWithAllParameters
{
    TCPlacesAutocompleteParameters *parameters = [[TCPlacesAutocompleteParameters alloc] init];
    parameters.input = @"Hello World!";
    parameters.location = CLLocationCoordinate2DMake(10.25, 20.25);
    parameters.radius = (CLLocationDistance)500;
    
    NSDictionary *dictionary = [parameters dictionary];
    
    STAssertEqualObjects(dictionary[@"input"], parameters.input,
                         @"Dictionary's \"input\" key should match object's input property.");
    STAssertEqualObjects(dictionary[@"location"], @"10.25,20.25",
                         @"Dictionary's \"location\" key's string value was not converted properly from a CLLocationCoordinate2D.");
    STAssertEqualObjects(dictionary[@"radius"], @"500",
                         @"Dictionary's \"radius\" key's string value was not converted properly from a CLLocationDistance.");
}

- (void)testParametersWithNoLocationBiasing
{
    TCPlacesAutocompleteParameters *parameters = [[TCPlacesAutocompleteParameters alloc] init];
    parameters.input = @"Hello World!";

    NSDictionary *dictionary = [parameters dictionary];
    
    STAssertNotNil(dictionary[@"input"], @"There should be an \"input\" key.");
    STAssertNil(dictionary[@"location"], @"There should be no \"location\" key, if no location is given.");
    STAssertNil(dictionary[@"radius"], @"There should be no \"radius\" key, if no location is given.");
}

- (void)testParametersWithNoInputShouldThrowException
{
    TCPlacesAutocompleteParameters *parameters = [[TCPlacesAutocompleteParameters alloc] init];
    
    STAssertThrows([parameters dictionary],
                   @"If required parameter \"input\" is nil, it should be caught by an NSAssert.");
}

- (void)testParametersWithEmptyInputShouldThrowException
{
    TCPlacesAutocompleteParameters *parameters = [[TCPlacesAutocompleteParameters alloc] init];
    parameters.input = @"";
    
    STAssertThrows([parameters dictionary],
                   @"If \"input\" parameter is an empty string, it should be caught by an NSAssert.");
}

- (void)testLocationIsInitializedToInvalidCoordinates
{
    STAssertFalse(CLLocationCoordinate2DIsValid(self.parameters.location),
                  @"location property should be initialized to kCLLocationCoordinate2DInvalid");
}

@end
