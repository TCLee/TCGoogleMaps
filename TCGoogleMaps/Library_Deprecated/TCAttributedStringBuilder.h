//
//  TCAttributedStringBuilder.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/23/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Contains methods to create NSAttributedString from a HTML string
 that is returned specifically from Google Directions API. It is not meant 
 for parsing generic HTML strings.
 */
@interface TCAttributedStringBuilder : NSObject

/*
 Creates and returns a new NSAttributedString from the given HTML string.
 */
+ (NSAttributedString *)attributedStringFromHTML:(NSString *)htmlString;

@end
