//
//  TCTestData.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/30/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Provides methods to load test data for the unit tests.
 */
@interface TCTestData : NSObject

/**
 * Returns a Foundation object loaded from given JSON file.
 *
 * @param filename the filename to load the JSON object from
 *
 * @return a valid Foundation object from the JSON file.
 */
+ (id)JSONObjectFromFilename:(NSString *)filename;

@end
