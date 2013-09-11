//
//  TCPlacesPredictionTerm.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/11/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A term that identifies a section of the autocomplete prediction 
 * description.
 */
@interface TCPlacesPredictionTerm : NSObject

/**
 * The offset or index, in unicode characters, of the start of this term 
 * in the description of the place.
 */
@property (nonatomic, assign, readonly) NSUInteger offset;

/**
 * The value of this term, e.g. "Taco Bell".
 */
@property (nonatomic, copy, readonly) NSString *value;

@end
