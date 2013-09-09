//
//  TCPlacesServiceStatus.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/5/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCPlacesServiceStatus : NSObject

/**
 * Returns a string that contains a description of the status code.
 *
 * @param statusCode the status code returned from Google Places API response
 *
 * @return a string containing the description of the status code.
 */
+ (NSString *)descriptionFromStatusCode:(NSString *)statusCode;

@end
