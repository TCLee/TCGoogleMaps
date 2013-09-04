//
//  TCPlacesAutocompleteServiceTests.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/3/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <CoreLocation/CLLocation.h>

#import "TCPlacesAutocompleteServiceTests.h"
#import "TCPlacesService.h"
#import "TCPlacesAutocompleteParameters.h"
#import "TCPlacesAutocompletePrediction.h"

@implementation TCPlacesAutocompleteServiceTests

- (void)testPlacesAutocompleteServiceWithSuccessResponse
{
    TCPlacesAutocompleteParameters *dummyParameters = [[TCPlacesAutocompleteParameters alloc] init];
    dummyParameters.input = @"Someplace";
    
    [[TCPlacesService sharedService] placePredictionsWithParameters:dummyParameters completion: ^(NSArray *predictions, NSError *error) {
        STAssertNil(error, @"Error should be nil on success.");
        STAssertNotNil(predictions, @"Predictions array should be non-nil on success.");
        
        for (TCPlacesAutocompletePrediction *prediction in predictions) {
            STAssertTrue([prediction isKindOfClass:[TCPlacesAutocompletePrediction class]],
                         @"Predictions array should contain only TCPlacesAutocompletePrediction instances.");
        }
    }];
}

- (void)testNilParametersShouldThrowException
{
    STAssertThrows([[TCPlacesService sharedService] placePredictionsWithParameters:nil completion:nil],
                   @"Passing in nil parameters should be caught by NSParameterAssert.");
}

@end
