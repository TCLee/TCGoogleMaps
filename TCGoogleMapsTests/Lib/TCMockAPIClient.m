//
//  TCMockAPIClient.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/5/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCMockAPIClient.h"
#import "TCGoogleMapsAPIClient.h"
#import "TCTestData.h"

@implementation TCMockAPIClient

+ (id)mockAPIClientWithResponseFromFilename:(NSString *)filename
{
    return [[self alloc] initWithResponseFromFilename:filename];
}

/**
 * Initializes a new mock API client object that gets its response data
 * from a local file stored in the test bundle.
 *
 * @param filename the filename in the test bundle to load the response data from
 *
 * @return an `OCMockObject` instance
 */
- (id)initWithResponseFromFilename:(NSString *)filename
{
    // Create a mock of the API client, so that we don't connect to Google's web services.
    self = [OCMockObject partialMockForObject:[TCGoogleMapsAPIClient sharedClient]];
    
    if (self) {
        // Replace the getPath:parameters:completion: method to return local JSON data.
        [[[self stub] andDo:^(NSInvocation *invocation) {
            // Get the completion block that was passed in by the test.
            // The arguments for the actual method start at index 2. (@see NSInvocation)
            TCGoogleMapsAPIClientCallback completionBlock = NULL;
            [invocation getArgument:&completionBlock atIndex:4];
            
            // Load the response object from the JSON data stored in the test bundle.
            id responseObject = [TCTestData JSONObjectFromFilename:filename];
            
            // Call the completion block with the response object.
            completionBlock(nil, responseObject, nil);            
        }] getPath:[OCMArg isNotNil] parameters:[OCMArg isNotNil] completion:[OCMArg isNotNil]];
    }
    
    return self;
}

@end
