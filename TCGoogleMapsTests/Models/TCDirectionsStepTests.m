//
//  TCDirectionsStepTests.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/29/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCDirectionsStepTests.h"
#import "TCTestData.h"
#import "TCDirectionsStep.h"
#import "TCDistance.h"
#import "TCDuration.h"

@implementation TCDirectionsStepTests

- (void)testInitWithValidProperties
{
    NSDictionary *properties = [TCTestData JSONObjectFromFilename:@"TCDirectionStepTestData"];
    TCDirectionsStep *step = [[TCDirectionsStep alloc] initWithProperties:properties];

    STAssertEquals(step.distance.value, (CLLocationDistance)200, @"The step's distance value does not match test data.");
    STAssertEqualObjects(step.distance.text, @"0.2 km", @"The step's distance text does not match test data.");
    
    STAssertEquals(step.duration.value, (NSTimeInterval)47, @"The step's duration value does not match test data.");
    STAssertEqualObjects(step.duration.text, @"1 min", @"The step's duration text does not match test data.");
    
    STAssertEquals(step.startLocation, CLLocationCoordinate2DMake(45.5101458, -73.5525249), @"The step's start location does not match test data.");
    STAssertEquals(step.endLocation, CLLocationCoordinate2DMake(45.5085712, -73.5537674), @"The step's end location does not match test data.");
    
    STAssertEqualObjects(step.instructions, @"Turn right onto Rue Notre-Dame E", @"The step's instructions does not match test data.");
    
    STAssertEqualObjects([step.path encodedPath], @"muwtGfv|_MfC`BVNt@n@RNZVt@n@", @"The step's path does not match test data.");    
}

- (void)testInitWithNilPropertiesShouldReturnNil
{
    TCDirectionsStep *step = [[TCDirectionsStep alloc] initWithProperties:nil];
    STAssertNil(step, @"TCDirectionsStep init with nil properties should also return nil.");
}

- (void)testNilHTMLInstructions
{
    NSDictionary *properties = @{};
    TCDirectionsStep *step = [[TCDirectionsStep alloc] initWithProperties:properties];
    
    STAssertNil(step.instructions, @"Plain text instructions should be nil given a nil HTML instruction string.");    
}

- (void)testHTMLInstructionsWithBoldAndDivElement
{
    NSDictionary *properties = @{@"html_instructions": @"<b>This</b> is some <b>bold</b> text.<div style=\"font-size:0.9em\">This is on a new line.</div>"};
    TCDirectionsStep *step = [[TCDirectionsStep alloc] initWithProperties:properties];
    
    STAssertEqualObjects(step.instructions, @"This is some bold text.\nThis is on a new line.", @"Failed to handle <div></div> HTML tags.");
}

- (void)testHTMLInstructionsWithBoldElementOnly
{
    NSDictionary *properties = @{@"html_instructions": @"<b>This</b> is some <b>bold</b> text."};
    TCDirectionsStep *step = [[TCDirectionsStep alloc] initWithProperties:properties];

    STAssertEqualObjects(step.instructions, @"This is some bold text.", @"Failed to strip out <b></b> HTML tags.");
}

@end
