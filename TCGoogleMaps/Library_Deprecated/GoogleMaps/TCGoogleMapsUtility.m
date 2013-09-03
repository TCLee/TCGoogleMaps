//
//  TCGoogleMapsUtility.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/26/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCGoogleMapsUtility.h"

@implementation TCGoogleMapsUtility

+ (CLLocationCoordinate2D)coordinateFromDictionary:(NSDictionary *)dictionary
{
    CLLocationDegrees latitude = [dictionary[@"lat"] doubleValue];
    CLLocationDegrees longitude = [dictionary[@"lng"] doubleValue];
    return CLLocationCoordinate2DMake(latitude, longitude);
}

+ (NSString *)stringFromCoordinate:(CLLocationCoordinate2D)coordinate
{
    return [NSString stringWithFormat:@"%f,%f", coordinate.latitude, coordinate.longitude];
}

+ (NSString *)stringFromBool:(BOOL)boolValue
{
    return boolValue ? @"true" : @"false";
}

@end
