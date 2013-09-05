//
//  TCPlacesAutocompletePredictionTests.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/4/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCPlacesAutocompletePredictionTests.h"
#import "TCPlacesAutocompletePrediction.h"

@implementation TCPlacesAutocompletePredictionTests

- (void)testInitWithValidProperties
{
    NSDictionary *properties = @{
        @"description"  : @"Starbucks, Fulton Street, San Francisco, CA, United States",
        @"reference"    : @"CoQBcwAAAJBa0bpD9U-ToQQJyu0UI6yuseuby52pwNH2_f7OrVw_W1_B9ZCcDlbMR_Q0fTcYjlh_hJ51ZbOImADyNt8W-6B1kvkirP-lrwW1i80jEANGPradWrqYzISvatJDnQF3fY3YwYBJ2hnBlh2QMOEMuB5lQjY0k5Jx-EudIApypFeUEhDuF5mFXA1-PLCGy8jqe2TIGhQzt-HbssuKa_m-N8ORs4MtEg68mQ"
    };
    TCPlacesAutocompletePrediction *prediction = [[TCPlacesAutocompletePrediction alloc] initWithProperties:properties];
    
    STAssertNotNil(prediction,
                   @"Prediction instance should be non-nil when init with valid properties.");
    
    STAssertEqualObjects(prediction.description, properties[@"description"],
                         @"Prediction's description property was not parsed properly.");
    STAssertEqualObjects(prediction.reference, properties[@"reference"],
                         @"Prediction's reference property was not parsed properly.");
}

- (void)testInitWithNilPropertiesShouldReturnNil
{
    TCPlacesAutocompletePrediction *prediction = [[TCPlacesAutocompletePrediction alloc] initWithProperties:nil];    
    STAssertNil(prediction, @"Prediction should be nil if it's passed in nil properties.");
}

@end
