//
//  TCPlacesAutocompletePrediction.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/4/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCPlacesAutocompletePrediction.h"

@implementation TCPlacesAutocompletePrediction

- (id)initWithProperties:(NSDictionary *)properties
{
    if (!properties) { return nil; }
    
    self = [super init];
    if (self) {
        _description = [properties[@"description"] copy];
        _reference = [properties[@"reference"] copy];
    }
    return self;
}

@end
