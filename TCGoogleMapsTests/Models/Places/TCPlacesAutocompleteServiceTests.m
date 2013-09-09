//
//  TCPlacesServiceTests.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/3/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <CoreLocation/CLLocation.h>
#import <OCMock/OCMock.h>

#import "TCPlacesAutocompleteServiceTests.h"
#import "TCGoogleMapsAPIClient.h"
#import "TCMockAPIClient.h"
#import "TCPlacesService.h"
#import "TCPlacesServiceError.h"
#import "TCPlacesAutocompleteParameters.h"
#import "TCPlacesAutocompletePrediction.h"

static NSString * const kDummyAPIKey = @"FAKE-API-KEY";

@implementation TCPlacesAutocompleteServiceTests

- (void)setUp
{
    [TCPlacesService setAPIKey:kDummyAPIKey sensor:YES];
    
    self.service = [TCPlacesService sharedService];
    
    self.parameters = [[TCPlacesAutocompleteParameters alloc] init];
    self.parameters.input = @"Test Input";
}

- (void)tearDown
{
    [TCPlacesService setAPIKey:nil sensor:NO];
    self.service.APIClient = nil;
    self.service = nil;
    self.parameters = nil;
}

- (void)testSharedServiceReturnsAValidInstance
{
    STAssertNotNil(self.service, @"[TCPlacesService sharedService] should create and return a non-nil TCPlacesService instance.");
    STAssertTrue([self.service isKindOfClass:[TCPlacesService class]], @"[TCPlacesService sharedService] should return an instance of class TCPlacesService.");
}

- (void)testNoAPIKeyProvidedShouldThrowException
{
    // Pass nil to simulate not providing an API key.
    [TCPlacesService setAPIKey:nil sensor:NO];
    
    STAssertThrows([self.service placePredictionsWithParameters:self.parameters completion:nil],
                   @"No API key is provided. Should be caught by NSAssert.");
}

- (void)testAPIKeyAndSensorParametersValues
{
    // Create a mock of the API client, so that we don't connect to Google's web services.
    id mockAPIClient = [OCMockObject niceMockForClass:[TCGoogleMapsAPIClient class]];
    
    __block NSDictionary *parameters = nil;
    
    // Replace the getPath:parameters:completion: method.
    [[[mockAPIClient stub] andDo:^(NSInvocation *invocation) {
        // Get the parameters dictionary that was passed in by the test.
        // The arguments for the actual method start at index 2. (@see NSInvocation)
        [invocation getArgument:&parameters atIndex:3];
        
        // Verify that the sensor and key parameters are provided.
        STAssertNotNil(parameters[@"sensor"],
                       @"'sensor' key should have been added to parameters dictionary.");
        STAssertNotNil(parameters[@"key"],
                       @"'key' key should have been added to parameters dictionary.");
        
        STAssertEqualObjects(parameters[@"sensor"], @"true",
                             @"'sensor' parameter should be set to 'true'.");
        STAssertEqualObjects(parameters[@"key"], kDummyAPIKey,
                             @"'key' parameter should be set to '%@'", kDummyAPIKey);
        
    }] getPath:[OCMArg any] parameters:[OCMArg isNotNil] completion:[OCMArg any]];
    
    // The service object will now use our mock API client, instead of
    // it's default API client.
    self.service.APIClient = mockAPIClient;    
    [self.service placePredictionsWithParameters:self.parameters completion:nil];
    
//    // We're done with the mock API client.
//    mockAPIClient = nil;
//    self.service.APIClient = nil;
}

/**
 * Test the workflow of Google Places Autocomplete API with a successful response.
 */
- (void)testPlacesAutocompleteWithSuccessResponse
{
    // Create a mock API client object to return response data from a local file in the test bundle.
    self.service.APIClient = [TCMockAPIClient mockAPIClientWithResponseFromFilename:@"TCPlacesAutocomplete_Success"];
    
    __block BOOL completionBlockWasCalled = NO;
    [self.service placePredictionsWithParameters:self.parameters completion: ^(NSArray *predictions, NSError *error) {
        completionBlockWasCalled = YES;
        
        STAssertNil(error, @"Error should be nil on success.");
        STAssertNotNil(predictions, @"Predictions array should be non-nil on success.");
        
        STAssertEquals([predictions count], (NSUInteger)5,
                       @"There number of prediction results in the array does not match the test data.");
        
        for (id prediction in predictions) {
            STAssertTrue([prediction isKindOfClass:[TCPlacesAutocompletePrediction class]],
                         @"All the prediction objects in the array should be "
                         "of class TCPlacesAutocompletePrediction.");
        }
    }];
    
    STAssertTrue(completionBlockWasCalled,
                 @"Completion block must be called on success.");
}

/**
 * Test the workflow of Google Places Autocomplete API with an error response.
 */
- (void)testPlacesAutocompleteWithErrorResponse
{
    // Create a mock API client object to return response data from a local file in the test bundle.
    self.service.APIClient = [TCMockAPIClient mockAPIClientWithResponseFromFilename:@"TCPlacesAutocomplete_Error"];
    
    __block BOOL completionBlockWasCalled = NO;
    [self.service placePredictionsWithParameters:self.parameters completion: ^(NSArray *predictions, NSError *error) {
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
    STAssertThrows([self.service placePredictionsWithParameters:nil completion:nil],
                   @"Passing in nil parameters should be caught by NSParameterAssert.");
}

@end
