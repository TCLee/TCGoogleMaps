//
//  TCDirectionsParameters.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/25/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCDirectionsParameters.h"
#import "TCGoogleMapsUtility.h"

NSString * const TCTravelModeDriving = @"DRIVING";
NSString * const TCTravelModeWalking = @"WALKING";
NSString * const TCTravelModeBicycling = @"BICYCLING";
NSString * const TCTravelModeTransit = @"TRANSIT";

@implementation TCDirectionsParameters

- (NSDictionary *)dictionary
{
    NSDictionary *parameters = @{@"origin": [TCGoogleMapsUtility stringFromCoordinate:self.origin],
                                 @"destination": [TCGoogleMapsUtility stringFromCoordinate:self.destination],
                                 @"sensor": @"false",
                                 @"mode": self.travelMode,
                                 @"alternatives": [TCGoogleMapsUtility stringFromBool:self.provideRouteAlternatives]};
    
    NSMutableDictionary *mutableParameters = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    
    // Add the optional "avoid" parameter only if requested.
    if (self.avoidTolls || self.avoidHighways) {
        mutableParameters[@"avoid"] = [self avoidParameterValue];
    }
    
    return [mutableParameters copy];
}

/**
 * Returns the string to be used as the 'avoid' request parameter's value.
 */
- (NSString *)avoidParameterValue
{    
    NSMutableString *value = [[NSMutableString alloc] init];
    
    if (self.avoidTolls) { [value appendString:@"tolls"]; }
    if (self.avoidTolls && self.avoidHighways) { [value appendString:@"|"]; }
    if (self.avoidHighways) { [value appendString:@"highways"]; }
    
    return value;
}

@end
