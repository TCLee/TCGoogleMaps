//
//  TCGoogleMapsUtility.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/26/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCDirectionsDataMapper.h"

@implementation TCDirectionsDataMapper

+ (GMSCoordinateBounds *)coordinateBoundsFromProperties:(NSDictionary *)properties
{
    CLLocationCoordinate2D northEastCoordinate = [TCDirectionsDataMapper coordinateFromProperties:properties[@"northeast"]];
    CLLocationCoordinate2D southWestCoordinate = [TCDirectionsDataMapper coordinateFromProperties:properties[@"southwest"]];
    GMSCoordinateBounds *coordinateBounds = [[GMSCoordinateBounds alloc] initWithCoordinate:northEastCoordinate coordinate:southWestCoordinate];
    return coordinateBounds;
}

+ (CLLocationCoordinate2D)coordinateFromProperties:(NSDictionary *)properties
{
    if (!properties) { return kCLLocationCoordinate2DInvalid; }
    
    CLLocationDegrees latitude = [properties[@"lat"] doubleValue];
    CLLocationDegrees longitude = [properties[@"lng"] doubleValue];
    return CLLocationCoordinate2DMake(latitude, longitude);
}

+ (NSString *)stringFromCoordinate:(CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DIsValid(coordinate) ?
           [NSString stringWithFormat:@"%f,%f", coordinate.latitude, coordinate.longitude] :
           nil;
}

+ (NSString *)stringFromBool:(BOOL)boolValue
{
    return boolValue ? @"true" : @"false";
}

@end
