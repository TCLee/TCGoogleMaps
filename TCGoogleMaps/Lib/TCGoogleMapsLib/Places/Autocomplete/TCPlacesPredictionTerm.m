//
//  TCPlacesPredictionTerm.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/11/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCPlacesPredictionTerm.h"

@implementation TCPlacesPredictionTerm

- (id)initWithProperties:(NSDictionary *)properties
{
    self = [super init];
    if (self) {
        _offset = [properties[@"offset"] unsignedIntegerValue];
        _value = [properties[@"value"] copy];
    }
    return self;
}

/**
 * Override the description method, so that we can use NSArray's
 * componentsJoinedByString: method to combine multiple terms together
 * in a string.
 */
- (NSString *)description
{
    return self.value;
}

@end
