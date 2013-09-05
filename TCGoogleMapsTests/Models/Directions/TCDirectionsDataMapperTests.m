//
//  TCDirectionsDataMapperTests.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/30/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCDirectionsDataMapperTests.h"

#import "TCGoogleMapsAPIDataMapper.h"
#import <GoogleMaps/GMSCoordinateBounds.h>
#import <CoreLocation/CLLocation.h>

@implementation TCDirectionsDataMapperTests

- (void)testCreateCoordinateFromNilProperties
{
    CLLocationCoordinate2D coordinate = [TCGoogleMapsAPIDataMapper coordinateFromProperties:nil];
    STAssertFalse(CLLocationCoordinate2DIsValid(coordinate),
                  @"Given nil properties, the returned coordinate should be kCLLocationCoordinate2DInvalid to indicate an error.");
}

- (void)testCreateCoordinateFromValidProperties
{
    CLLocationDegrees latitude = 50.0f;
	CLLocationDegrees longitude = 100.0f;
    NSDictionary *properties = @{@"lat": @(latitude), @"lng": @(longitude)};
    CLLocationCoordinate2D coordinate = [TCGoogleMapsAPIDataMapper coordinateFromProperties:properties];
    
    STAssertEquals(coordinate.latitude, latitude, @"Coordinate's latitude was not parsed properly.");
    STAssertEquals(coordinate.longitude, longitude, @"Coordinate's longitude was not parsed properly.");
}

- (void)testCreateCoordinateBoundsFromProperties
{
    CLLocationCoordinate2D northEastCoord = CLLocationCoordinate2DMake(40.5, -80.5);
    CLLocationCoordinate2D southWestCoord = CLLocationCoordinate2DMake(34.5, -118.5);
    NSDictionary *properties = @{
        @"southwest": @{
            @"lat": @(southWestCoord.latitude),
            @"lng": @(southWestCoord.longitude)
        },
        @"northeast": @{
            @"lat": @(northEastCoord.latitude),
            @"lng": @(northEastCoord.longitude)
        }
    };
    GMSCoordinateBounds *bounds = [TCGoogleMapsAPIDataMapper coordinateBoundsFromProperties:properties];
    
    STAssertEquals(bounds.northEast, northEastCoord, @"GMSCoordinateBounds's northEast property value is incorrect.");
    STAssertEquals(bounds.southWest, southWestCoord, @"GMSCoordinateBounds's southWest property value is incorrect.");
}

- (void)testStringFromBoolYES
{
    NSString *boolString = [TCGoogleMapsAPIDataMapper stringFromBool:YES];
    STAssertEqualObjects(boolString, @"true", @"A BOOL value of YES should return the string \"true\"");
}

- (void)testStringFromBoolNO
{
    NSString *boolString = [TCGoogleMapsAPIDataMapper stringFromBool:NO];
    STAssertEqualObjects(boolString, @"false", @"A BOOL value of NO should return the string \"false\"");
}

- (void)testStringFromCoordinateValid
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(10.5f, 20.5f);
    NSString *coordinateString = [TCGoogleMapsAPIDataMapper stringFromCoordinate:coordinate];    
    STAssertEqualObjects(coordinateString, @"10.500000,20.500000", @"String does not represent the CLLocationCoordinate2D value passed to it.");
}

- (void)testStringFromCoordinateInvalidReturnsNil
{
    NSString *coordinateString = [TCGoogleMapsAPIDataMapper stringFromCoordinate:kCLLocationCoordinate2DInvalid];
    STAssertNil(coordinateString, @"String should return nil if given invalid coordinates.");
}

@end
