//
//  TCPlacesServiceTests.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/3/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <CoreLocation/CLLocation.h>

#import "TCPlacesServiceTests.h"
#import "TCMockAPIClient.h"
#import "TCPlacesService.h"
#import "TCPlacesServiceError.h"
#import "TCPlacesAutocompleteParameters.h"
#import "TCPlacesAutocompletePrediction.h"

@implementation TCPlacesServiceTests

- (void)testSharedServiceReturnsAValidInstance
{
    id service = [TCPlacesService sharedService];
    
    STAssertNotNil(service, @"[TCPlacesService sharedService] should create and return a non-nil TCPlacesService instance.");
    STAssertTrue([service isKindOfClass:[TCPlacesService class]], @"[TCPlacesService sharedService] should return an instance of class TCPlacesService.");
}

/**
 * Test the workflow of Google Places Autocomplete API with a successful response.
 */
- (void)testPlacesAutocompleteWithSuccessResponse
{
    // Creating placeholder parameters. Does not matter what values we use.
    TCPlacesAutocompleteParameters *dummyParameters = [[TCPlacesAutocompleteParameters alloc] init];
    dummyParameters.input = @"Whatever";
    
    // Create a mock API client object to return response data from a local file in the test bundle.
    TCPlacesService *service = [TCPlacesService sharedService];
    service.APIClient = [TCMockAPIClient mockAPIClientWithResponseFromFilename:@"TCPlacesAutocomplete_Success"];
        
    __block BOOL completionBlockWasCalled = NO;
    [service placePredictionsWithParameters:dummyParameters completion: ^(NSArray *predictions, NSError *error) {
        completionBlockWasCalled = YES;
        
        STAssertNil(error, @"Error should be nil on success.");
        STAssertNotNil(predictions, @"Predictions array should be non-nil on success.");
        
        STAssertEquals([predictions count], (NSUInteger)5,
                       @"There should be 5 prediction results in the array.");
        
        for (id prediction in predictions) {
            STAssertTrue([prediction isKindOfClass:[TCPlacesAutocompletePrediction class]],
                         @"All the prediction objects in the array should be "
                         "of class TCPlacesAutocompletePrediction.");
        }
    }];
    
    STAssertTrue(completionBlockWasCalled,
                 @"Completion block must be called on success. Otherwise, client code will never know when it's completed.");
}

/**
 * Test the workflow of Google Places Autocomplete API with an error response.
 */
- (void)testPlacesAutocompleteWithErrorResponse
{
    // Creating placeholder parameters. Does not matter what values we use.
    TCPlacesAutocompleteParameters *dummyParameters = [[TCPlacesAutocompleteParameters alloc] init];
    dummyParameters.input = @"Whatever";
    
    // Create a mock API client object to return response data from a local file in the test bundle.
    TCPlacesService *service = [TCPlacesService sharedService];
    service.APIClient = [TCMockAPIClient mockAPIClientWithResponseFromFilename:@"TCPlacesAutocomplete_Error"];
    
    __block BOOL completionBlockWasCalled = NO;
    [service placePredictionsWithParameters:dummyParameters completion: ^(NSArray *predictions, NSError *error) {
        completionBlockWasCalled = YES;
        
        STAssertNotNil(error, @"Error should be non-nil on error.");
        STAssertNil(predictions, @"Predictions array should be nil on error.");
        
        STAssertNotNil([error localizedDescription],
                       @"Error object should have a valid description of the failure.");
                
        STAssertEqualObjects(error.userInfo[TCPlacesServiceStatusCodeErrorKey], @"REQUEST_DENIED",
                             @"The error's status code does not match the status code returned by the API.");
    }];
    
    STAssertTrue(completionBlockWasCalled,
                 @"Completion block must be called on error. Otherwise, client code will never know when it's completed.");
}

- (void)testPlacesAutocompleteWithNilParametersShouldThrowException
{
    STAssertThrows([[TCPlacesService sharedService] placePredictionsWithParameters:nil completion:^(NSArray *predictions, NSError *error) {
        // Do nothing. It's just a dummy block.
    }], @"Passing in nil parameters should be caught by NSParameterAssert.");
}

- (void)testPlacesAutocompleteWithNilCompletionBlockShouldThrowException
{
    TCPlacesAutocompleteParameters *dummyParameters = [[TCPlacesAutocompleteParameters alloc] init];
    STAssertThrows([[TCPlacesService sharedService] placePredictionsWithParameters:dummyParameters completion:nil],
                   @"Passing in nil for completion block should be caught by NSParameterAssert.");
}

@end
