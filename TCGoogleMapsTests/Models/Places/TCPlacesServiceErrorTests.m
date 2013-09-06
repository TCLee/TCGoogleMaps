//
//  TCPlacesServiceErrorTests.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/6/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCPlacesServiceErrorTests.h"
#import "TCPlacesServiceError.h"
#import "TCPlacesServiceStatus.h"

@implementation TCPlacesServiceErrorTests

- (void)testCreateErrorWithValidStatusCode
{
    NSError *error = [TCPlacesServiceError errorWithStatusCode:TCPlacesServiceStatusZeroResults];
    
    STAssertNotNil(error, @"Error object should be created, if given valid status code.");
    STAssertEqualObjects(error.userInfo[TCPlacesServiceStatusCodeErrorKey], TCPlacesServiceStatusZeroResults,
                         @"Error's status code does not match Google's API status code.");
    STAssertNotNil([error localizedDescription],
                   @"Error object should have a valid description.");
}

- (void)testCreateErrorWithInvalidStatusCodeShouldThrowException
{
    STAssertThrows([TCPlacesServiceError errorWithStatusCode:@"INVALID_STATUS_CODE"],
                   @"Attempting to create a NSError object with an invalid status code should be caught by NSAssert.");
}

@end
