//
//  TCMockAPIClient.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/5/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OCMock/OCMock.h>

/**
 * A mock API client that gets its response data from a local file stored 
 * in the test bundle.
 */
@interface TCMockAPIClient : OCMockObject

/**
 * Creates and returns a mock API client object that gets its response data 
 * from a local file stored in the test bundle.
 *
 * @param filename the filename in the test bundle to load the response data from
 *
 * @return an `OCMockObject` instance
 */
+ (id)mockAPIClientWithResponseFromFilename:(NSString *)filename;

@end
