//
//  TCPlacesAutocompletePrediction.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/4/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCPlacesAutocompletePrediction.h"
#import "TCPlacesPredictionTerm.h"
#import "TCPlacesPredictionTermPrivate.h"

@implementation TCPlacesAutocompletePrediction

- (id)initWithProperties:(NSDictionary *)properties
{
    if (!properties) { return nil; }
    
    self = [super init];
    if (self) {
        _description = [properties[@"description"] copy];
        _reference = [properties[@"reference"] copy];
        _terms = PredictionTermsFromResponse(properties[@"terms"]);
    }
    return self;
}

/**
 * Returns an array of TCPlacesPredictionTerm objects from
 * the response data.
 */
static NSArray *PredictionTermsFromResponse(NSArray *response)
{
    NSMutableArray *terms = [[NSMutableArray alloc] initWithCapacity:
                             [response count]];
    for (NSDictionary *termResponse in response) {
        TCPlacesPredictionTerm *term = [[TCPlacesPredictionTerm alloc] initWithProperties:termResponse];
        [terms addObject:term];
    }    
    return [terms copy];
}

@end
