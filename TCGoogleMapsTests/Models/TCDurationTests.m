//
//  TCDurationTests.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/31/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCDurationTests.h"
#import "TCDuration.h"

@implementation TCDurationTests

- (void)testInitWithValidProperties
{
    NSTimeInterval const value = 60.0f;
    NSString * const text = @"1 minute";
    NSDictionary * const properties = @{@"value": @(value), @"text": text};
    
    TCDuration *duration = [[TCDuration alloc] initWithProperties:properties];
    STAssertEquals(duration.value, value, @"TCDuration value property is set to an incorrect value.");
    STAssertEqualObjects(duration.text, text, @"TCDuration text property is set to an incorrect value.");
}

- (void)testInitWithNilShouldReturnNil
{
    TCDuration *duration = [[TCDuration alloc] initWithProperties:nil];
    STAssertNil(duration, @"TCDuration init with nil should also return nil.");
}

@end
