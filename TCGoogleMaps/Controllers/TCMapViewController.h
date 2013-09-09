//
//  TCMapViewController.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/17/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

/**
 * View Controller to display the Google Maps view.
 */
@interface TCMapViewController : UIViewController

/**
 * A unique token that you can use to retrieve additional information
 * about this place in a Place Details request.
 */
@property (nonatomic, copy) NSString *placeReference;

/**
 * The user's current location.
 */
@property (nonatomic, strong) CLLocation *myLocation;

@end
