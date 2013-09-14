//
//  TCUserLocation.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/9/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 * The callback block when user's location is found or there's an error.
 *
 * @param userLocation the user's current location or nil on error
 * @param error the error object describing why user's location is not available
 */
typedef void (^TCUserLocationCallback) (CLLocation *userLocation, NSError *error);

/**
 * This class provides methods to find the user's current location.
 */
@interface TCUserLocationManager : NSObject <CLLocationManagerDelegate>

/**
 * Start attempting to locate user.
 *
 * @param completion the block to be called when user's location is ready
 *                   or there's an error
 */
- (void)startLocatingUserWithCompletion:(TCUserLocationCallback)completion;

/**
 * Stop attempting to locate user.
 */
- (void)stopLocatingUser;

@end
