//
//  TCPlacesServiceError.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/5/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>
    
@interface TCPlacesServiceError : NSObject

/**
 * Creates and returns an `NSError` object from the status code
 * returned by Google Places API.
 *
 * @param statusCode the status code string returned in the Google Places API 
 *                   response
 *
 * @return an `NSError` object
 */
+ (NSError *)errorWithStatusCode:(NSString *)statusCode;

@end
