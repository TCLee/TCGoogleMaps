//
//  TCAttributedStringBuilder.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/23/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCAttributedStringBuilder.h"

@implementation TCAttributedStringBuilder

+ (NSAttributedString *)attributedStringFromHTML:(NSString *)htmlString
{
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:htmlString];
    
    // Apply bold attribute to all the characters between the HTML bold tags <b>...</b>.
    NSRange searchRange = NSMakeRange(0, [mutableAttributedString length]);
    while (searchRange.location != NSNotFound) {
        searchRange = [[self class] setBoldAttributeWithMutableAttributedString:mutableAttributedString
                                                                          range:searchRange];
    }

    // Set style attributes for the HTML <div>...</div> tags.
    [[self class] setDivAttributesWithMutableAttributedString:mutableAttributedString];
    
    return [mutableAttributedString copy];
}

/*
 Apply style attribute to the characters found in between HTML div tags <div>...</div>.
 It also removes the HTML <div></div> tags after that.

 @param mutableAttributedString the NSMutableAttributedString to set the attributes for
 */
+ (void)setDivAttributesWithMutableAttributedString:(NSMutableAttributedString *)mutableAttributedString
{
    // Find the opening <div> tag.
    NSRange openingDivTagRange = [[mutableAttributedString string] rangeOfString:@"<div.*?>"
                                                                         options:NSRegularExpressionSearch|NSCaseInsensitiveSearch
                                                                           range:NSMakeRange(0, [mutableAttributedString length])];
    // If no opening <div> tag found, we're done.
    if (NSNotFound == openingDivTagRange.location) {
        return;
    }

    // Find the closing </div> tag.
    NSUInteger afterOpeningDivTagLocation = NSMaxRange(openingDivTagRange);
    NSUInteger remainingStringLength = [mutableAttributedString length] - afterOpeningDivTagLocation;
    NSRange closingDivTagRange = [[mutableAttributedString string] rangeOfString:@"</div>"
                                                                     options:NSCaseInsensitiveSearch
                                                                       range:NSMakeRange(afterOpeningDivTagLocation, remainingStringLength)];
    NSAssert(NSNotFound != closingDivTagRange.location, @"Invalid HTML. Opening <div> tag with no closing tag </div>.");

    // Find the range of characters to apply style attribute to.
    NSUInteger textContentLength = closingDivTagRange.location - afterOpeningDivTagLocation;
    NSDictionary *styleAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                      NSForegroundColorAttributeName: [UIColor grayColor]};
    [mutableAttributedString setAttributes:styleAttributes
                                     range:NSMakeRange(afterOpeningDivTagLocation, textContentLength)];
    
    // Replace the opening <div> tag with a new line character \n.
    [mutableAttributedString replaceCharactersInRange:openingDivTagRange
                                           withString:@"\n"];
    
    // Update closing </div> tag range's location after opening <div> tag has
    // been replaced with a new line character \n.
    closingDivTagRange.location = closingDivTagRange.location - openingDivTagRange.length + 1; // +1 is for '\n'
    
    // Delete the closing </div> tag.
    [mutableAttributedString deleteCharactersInRange:closingDivTagRange];
}

/*
 Sets a bold attribute to the characters found in between HTML bold tags <b>...</b>.
 It also removes the HTML bold tags after that.
 
 @param mutableAttributedString the NSMutableAttributedString to set the attributes for
 @param searchRange the range to search for the HTML bold tags <b></b>
 
 @return An NSRange structure with the location and length for the next search range.
         Returns {NSNotFound, 0} if no HTML bold tags found or it has reached the end of the string.
 */
+ (NSRange)setBoldAttributeWithMutableAttributedString:(NSMutableAttributedString *)mutableAttributedString range:(NSRange)searchRange
{
    // Find the first opening HTML bold tag <b>.
    NSRange openingBoldTagRange = [[mutableAttributedString string] rangeOfString:@"<b>"
                                                                          options:NSCaseInsensitiveSearch
                                                                            range:searchRange];
    // If no opening HTML bold tag <b> found, then there's nothing to bold.
    if (NSNotFound == openingBoldTagRange.location) {
        return openingBoldTagRange;
    }
    
    // Find the matching closing HTML bold tag </b>.
    NSUInteger afterOpeningBoldTagLocation = NSMaxRange(openingBoldTagRange);
    NSUInteger remainingStringLength = [mutableAttributedString length] - afterOpeningBoldTagLocation;
    NSRange closingBoldTagRange = [[mutableAttributedString string] rangeOfString:@"</b>"
                                                                          options:NSCaseInsensitiveSearch
                                                                            range:NSMakeRange(afterOpeningBoldTagLocation, remainingStringLength)];
    NSAssert(NSNotFound != closingBoldTagRange.location, @"Invalid HTML. Opening bold tag <b> with no closing tag </b>.");
    
    // Find the range of characters to apply the bold attribute to.
    // Example:<b>Hello World</b>
    NSUInteger textContentLength = closingBoldTagRange.location - afterOpeningBoldTagLocation;
    [mutableAttributedString setAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f]}
                                     range:NSMakeRange(afterOpeningBoldTagLocation, textContentLength)];
    
    // Remove the HTML bold <b></b> tags.
    [mutableAttributedString deleteCharactersInRange:openingBoldTagRange];
    // Closing HTML bold <b> tag range's location would have changed since
    // opening HTML bold <b> tag has been removed.
    closingBoldTagRange.location -= openingBoldTagRange.length;
    [mutableAttributedString deleteCharactersInRange:closingBoldTagRange];
        
    // Return the range to start searching for the next bold tags <b>...</b>.
    // Start searching from the closing HTML bold tag </b> that has just been removed.
    NSUInteger nextSearchLocation = closingBoldTagRange.location;
    
    if (nextSearchLocation >= [mutableAttributedString length]) {
        // If we've already reached the end of the string, then we're done.
        return NSMakeRange(NSNotFound, 0);
    } else {
        // Else calculate the remaining length of the string yet to be parsed.
        NSUInteger remainingStringLength = [mutableAttributedString length] - nextSearchLocation;
        return NSMakeRange(nextSearchLocation, remainingStringLength);
    }
}

@end
