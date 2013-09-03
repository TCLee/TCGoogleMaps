//
//  TCDuration.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/25/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCDuration.h"

@implementation TCDuration

- (id)initWithProperties:(NSDictionary *)properties
{
    if (!properties) { return nil; }
    
    self = [super init];
    if (self) {
        _value = [properties[@"value"] doubleValue];
        _text = properties[@"text"];
    }
    return self;
}

@end
