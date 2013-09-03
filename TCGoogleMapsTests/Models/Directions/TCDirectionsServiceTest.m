//
//  TCDirectionsServiceTest.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/1/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <OCMock/OCMock.h>

#import "TCDirectionsServiceTest.h"
#import "TCTestData.h"
#import "TCGoogleMapsAPIClient.h"
#import "TCDirectionsService.h"
#import "TCDirectionsParameters.h"
#import "TCDirectionsRoute.h"

/**
 * Add a category for unit testing methods.
 */
@interface TCDirectionsService (UnitTestAdditions)
/**
 * We will replace this method with our own that returns a mock API 
 * client object.
 */
- (TCGoogleMapsAPIClient *)APIClient;
@end

@implementation TCDirectionsServiceTest

/**
 * Tutorials on how to mock networking code for unit testing.
 *
 * @see http://ashfurrow.com/blog/your-first-objective-c-unit-test
 * @see http://matthiaswessendorf.wordpress.com/2012/11/21/ocmock-and-afnetworking/
 * @see http://stackoverflow.com/a/9922272
 * @see http://www.infinite-loop.dk/blog/2011/04/using-mock-objects-to-stabilize-unit-tests/
 */
- (void)setUp
{
    // It does not matter what values we use for the directions parameters,
    // so as long as it's valid.
    self.dummyParameters = [[TCDirectionsParameters alloc] init];
    self.dummyParameters.origin = CLLocationCoordinate2DMake(10, 10);
    self.dummyParameters.destination = CLLocationCoordinate2DMake(20, 20);
}

- (void)tearDown
{
    self.dummyParameters = nil;
}

- (void)testDirectionsAPIWithOneRouteResponse
{
    id mockAPIClient = [self mockAPIClientWithResponseDataFromFilename:@"TCDirectionsServiceTests_OneRoute"];
    id partialServiceMock = [self partialServiceMockWithMockAPIClient:mockAPIClient];
    
    [partialServiceMock routeWithParameters:self.dummyParameters completion:^(NSArray *routes, NSError *error) {
        STAssertNil(error, @"Error should be nil on success.");
        STAssertEquals([routes count], (NSUInteger)1, @"There should only be one route in the response.");
        STAssertTrue([routes[0] isKindOfClass:[TCDirectionsRoute class]], @"The route should be of class TCDirectionsRoute.");
    }];
}

- (void)testDirectionsAPIWithMultipleRoutesResponse
{
    id mockAPIClient = [self mockAPIClientWithResponseDataFromFilename:@"TCDirectionsServiceTests_AlternativeRoutes"];
    id partialServiceMock = [self partialServiceMockWithMockAPIClient:mockAPIClient];
    
    [partialServiceMock routeWithParameters:self.dummyParameters completion:^(NSArray *routes, NSError *error) {
        STAssertNil(error, @"Error should be nil on success.");
        STAssertEquals([routes count], (NSUInteger)3, @"There should be 3 alternative routes in the response.");

        // Make sure all the routes in the array are of the correct type.
        for (TCDirectionsRoute *route in routes) {
            STAssertTrue([route isKindOfClass:[TCDirectionsRoute class]], @"The route should be of class TCDirectionsRoute.");
        }
    }];
}

/**
 * We are just testing one of the error status codes returned by 
 * Google Directions API. The rest of the error status codes are handled
 * similarly, so we're skipping the tests for them. If we do encounter
 * any bugs later due to this, we will add tests to cover them.
 */
- (void)testDirectionsAPIWithErrorStatusNotFound
{
    id mockAPIClient = [self mockAPIClientWithResponseDataFromFilename:@"TCDirectionsServiceTests_NotFound"];
    id partialServiceMock = [self partialServiceMockWithMockAPIClient:mockAPIClient];
    
    [partialServiceMock routeWithParameters:self.dummyParameters completion:^(NSArray *routes, NSError *error) {
        STAssertNotNil(error, @"Error should have a value on failure.");
        STAssertNil(routes, @"Routes array should be nil on error.");
        
        NSString *statusCode = error.userInfo[TCDirectionsStatusCodeErrorKey];
        STAssertEqualObjects(statusCode, @"NOT_FOUND", @"Status code returned should be NOT_FOUND");
        
        STAssertNotNil([error localizedDescription], @"Error object should have a localized description string.");
    }];
}

- (void)testDirectionsAPIWithNilParameters
{
    STAssertThrows([[TCDirectionsService sharedService] routeWithParameters:nil completion:nil],
                   @"Calling Google Directions API with no parameters should be caught by NSParameterAssert.");
}

#pragma mark - Mock Objects Setup

/**
 * Creates and returns a mock of TCGoogleMapsAPIClient object. The mock
 * object loads the response object from the JSON file stored in the 
 * test bundle.
 *
 * @param filename the filename of the JSON file to load the response object from
 *
 * @return a mock of TCGoogleMapsAPIClient object
 */
- (id)mockAPIClientWithResponseDataFromFilename:(NSString *)filename
{
    // Create a mock of the API client, so that we don't connect to Google's web services.
    id mockAPIClient = [OCMockObject niceMockForClass:[TCGoogleMapsAPIClient class]];
    
    // Replace the getPath:parameters:completion: method to return local JSON data.
    [[[mockAPIClient stub] andDo:^(NSInvocation *invocation) {
        // Get the completion block that was passed in by the test.
        // The arguments for the actual method start at index 2. (@see NSInvocation)
        TCGoogleMapsAPIClientCallback completionBlock = NULL;
        [invocation getArgument:&completionBlock atIndex:4];
        
        // Load the response object from the JSON data stored in the test bundle.
        id responseObject = [TCTestData JSONObjectFromFilename:filename];
        
        // Call the completion block with the response object.
        completionBlock(nil, responseObject, nil);
    }] getPath:[OCMArg isNotNil] parameters:[OCMArg isNotNil] completion:[OCMArg isNotNil]];
    
    return mockAPIClient;
}

/**
 * Creates and returns a partial mock of TCDirectionsService object
 * that uses a mock TCGoogleMapsAPIClient object to load the response object 
 * from a JSON file in the test bundle.
 *
 * @param mockAPIClient a mock of TCGoogleMapsAPIClient object
 *
 * @return a partial mock of TCDirectionsService object
 */
- (id)partialServiceMockWithMockAPIClient:(id)mockAPIClient
{
    // Create the actual service object that we want to test.
    TCDirectionsService *serviceUnderTest = [TCDirectionsService sharedService];
    
    // Create a partial mock for our service object. Stub the "APIClient" method
    // to return the mock API client that we've just created.
    id partialServiceMock = [OCMockObject partialMockForObject:serviceUnderTest];
    [[[partialServiceMock stub] andReturn:mockAPIClient] APIClient];
    
    return partialServiceMock;
}

@end
