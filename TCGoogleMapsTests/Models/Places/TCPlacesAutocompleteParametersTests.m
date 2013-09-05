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

- (void)testParametersDictionaryRepresentation
{
    TCPlacesAutocompleteParameters *parameters = [[TCPlacesAutocompleteParameters alloc] init];
    parameters.input = @"Hello World!";
    parameters.location = CLLocationCoordinate2DMake(10.5, 20.5);
    parameters.radius = (CLLocationDistance)500;
    
    NSDictionary *dictionary = [parameters dictionary];
    
    STAssertEqualObjects(dictionary[@"input"], parameters.input,
                         @"Dictionary's \"input\" key should match object's input property.");
    STAssertEqualObjects(dictionary[@"location"], @"10.500000,20.500000",
                         @"Dictionary's \"location\" key's string value was not converted properly from a CLLocationCoordinate2D.");
    STAssertEqualObjects(dictionary[@"radius"], @"500.000000",
                         @"Dictionary's \"radius\" key's string value was not converted properly from a CLLocationDistance.");
}

- (void)testParametersDictionaryRepresentationWithNoLocationBiasing
{
    TCPlacesAutocompleteParameters *parameters = [[TCPlacesAutocompleteParameters alloc] init];
    parameters.input = @"Hello World!";

    NSDictionary *dictionary = [parameters dictionary];
    
    STAssertNotNil(dictionary[@"input"], @"There should be an \"input\" key.");
    STAssertNil(dictionary[@"location"], @"There should be no \"location\" key, if no location is given.");
    STAssertNil(dictionary[@"radius"], @"There should be no \"radius\" key, if no location is given.");
}

- (void)testParametersDictionaryRepresentationWithNoInput
{
    TCPlacesAutocompleteParameters *parameters = [[TCPlacesAutocompleteParameters alloc] init];
    NSDictionary *dictionary = [parameters dictionary];
    
    STAssertEqualObjects(dictionary[@"input"], @"",
                         @"The \"input\" should be an empty string, even if it's not set to a value.");
}

@end
