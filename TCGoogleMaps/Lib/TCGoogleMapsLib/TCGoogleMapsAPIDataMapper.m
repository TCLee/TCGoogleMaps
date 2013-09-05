//
//  TCGoogleMapsUtility.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/26/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCGoogleMapsAPIDataMapper.h"

@implementation TCGoogleMapsAPIDataMapper

+ (GMSCoordinateBounds *)coordinateBoundsFromProperties:(NSDictionary *)properties
{
    CLLocationCoordinate2D northEastCoordinate = [TCGoogleMapsAPIDataMapper coordinateFromProperties:properties[@"northeast"]];
    CLLocationCoordinate2D southWestCoordinate = [TCGoogleMapsAPIDataMapper coordinateFromProperties:properties[@"southwest"]];
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
    // Returns nil on invalid coordinates.
    if (!CLLocationCoordinate2DIsValid(coordinate)) {
        return nil;
    }
    
    NSString *latitudeString = [@(coordinate.latitude) stringValue];
    NSString *longitudeString = [@(coordinate.longitude) stringValue];
    return [NSString stringWithFormat:@"%@,%@", latitudeString, longitudeString];
}

+ (NSString *)stringFromBool:(BOOL)boolValue
{
    return boolValue ? @"true" : @"false";
}

@end
