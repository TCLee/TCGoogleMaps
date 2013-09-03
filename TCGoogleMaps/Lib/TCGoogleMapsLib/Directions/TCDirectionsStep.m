//
//  TCDirectionsStep.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/24/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCDirectionsStep.h"
#import "TCDistance.h"
#import "TCDuration.h"
#import "TCDirectionsDataMapper.h"

@implementation TCDirectionsStep

- (id)initWithProperties:(NSDictionary *)properties
{
    if (!properties) { return nil; }
    
    self = [super init];
    if (self) {
        _instructions = [self plainTextFromHTML:properties[@"html_instructions"]];
        _distance = [[TCDistance alloc] initWithProperties:properties[@"distance"]];
        _duration = [[TCDuration alloc] initWithProperties:properties[@"duration"]];
        _startLocation = [TCDirectionsDataMapper coordinateFromProperties:properties[@"start_location"]];
        _endLocation = [TCDirectionsDataMapper coordinateFromProperties:properties[@"end_location"]];
        _path = [GMSPath pathFromEncodedPath:properties[@"polyline"][@"points"]];        
    }
    return self;
}

/**
 *  Strips all tags from the HTML string and returns a plain text version of it.
 *
 *  @param html The HTML string to strip the tags from
 *
 *  @return A plain text version of the HTML string.
 */
- (NSString *)plainTextFromHTML:(NSString *)html
{
    // We can't do anything with anything with an empty HTML string.
    if (!html || 0 == [html length]) { return nil; }
    
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:html];
    
    // Since the HTML returned from Google Directions API is simple and predictable
    // enough, we will use regular expression to parse and remove the HTML tags.
    
    // Remove all the HTML bold tags <b></b>.
    [mutableString replaceOccurrencesOfString:@"</?b>"
                                   withString:@""
                                      options:NSRegularExpressionSearch|NSCaseInsensitiveSearch
                                        range:NSMakeRange(0, [mutableString length])];
    
    // Replace the opening <div> tag with a new line character '\n'.
    [mutableString replaceOccurrencesOfString:@"<div.*?>"
                                   withString:@"\n"
                                      options:NSRegularExpressionSearch|NSCaseInsensitiveSearch
                                        range:NSMakeRange(0, [mutableString length])];
    
    // Remove the closing </div> tag.
    [mutableString replaceOccurrencesOfString:@"</div>"
                                   withString:@""
                                      options:NSCaseInsensitiveSearch
                                        range:NSMakeRange(0, [mutableString length])];
    
    return [mutableString copy];
}

@end
