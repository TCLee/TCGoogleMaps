//
//  TCPlace.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/9/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Place result returned by Google Place Details API.
 */
@interface TCPlace : NSObject

/**
 * The name of the place.
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 * Short-form address of the place.
 */
@property (nonatomic, copy, readonly) NSString *address;

/**
 * The place's coordinates.
 */
@property (nonatomic, assign, readonly) CLLocationCoordinate2D location;

@end
