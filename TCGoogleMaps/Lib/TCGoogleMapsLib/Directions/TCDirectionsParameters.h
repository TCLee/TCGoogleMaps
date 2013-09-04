//
//  TCDirectionsParameters.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/25/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 * Default travel mode if none specified. 
 * Indicates standard driving directions using the road network.
 */
FOUNDATION_EXPORT NSString * const TCTravelModeDriving;
/**
 * Requests walking directions via pedestrian paths & sidewalks (where available).
 */
FOUNDATION_EXPORT NSString * const TCTravelModeWalking;
/**
 * Requests bicycling directions via bicycle paths & preferred streets (where available).
 */
FOUNDATION_EXPORT NSString * const TCTravelModeBicycling;
/**
 * Requests directions via public transit routes (where available).
 */
FOUNDATION_EXPORT NSString * const TCTravelModeTransit;

/**
 * Encapsulates the request parameters to be sent to TCDirectionsService.
 */
@interface TCDirectionsParameters : NSObject

/**
 * Location of origin. Required.
 */
@property (nonatomic, assign) CLLocationCoordinate2D origin;

/**
 * Location of destination. Required.
 */
@property (nonatomic, assign) CLLocationCoordinate2D destination;

/**
 * If YES, instructs the Directions service to avoid highways 
 * where possible. Defaults to NO. Optional.
 */
@property (nonatomic, assign) BOOL avoidHighways;

/**
 * If YES, instructs the Directions service to avoid toll roads 
 * where possible. Defaults to NO. Optional.
 */
@property (nonatomic, assign) BOOL avoidTolls;

/**
 * If set to YES, specifies that the Directions service may provide 
 * more than one route alternative in the response. Note that providing 
 * route alternatives may increase the response time from the server.
 * Defaults to NO. Optional.
 */
@property (nonatomic, assign) BOOL provideRouteAlternatives;

/**
 * Specifies the mode of transport to use when calculating directions.
 * Defaults to TCTravelModeDriving. Optional.
 *
 * @see TCTravelMode constants
 */
@property (nonatomic, copy) NSString *travelMode;

/**
 * Returns the dictionary representation of this TCDirectionsParameters instance.
 */
- (NSDictionary *)dictionary;

@end
