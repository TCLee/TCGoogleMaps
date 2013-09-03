//
//  TCTestData.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/30/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCTestData.h"

#import <SenTestingKit/SenTestingKit.h>

@implementation TCTestData

+ (id)JSONObjectFromFilename:(NSString *)filename
{
    // Test data is stored in the test bundle, NOT the main bundle.
    NSURL *testDataURL = [[NSBundle bundleForClass:[self class]] URLForResource:filename withExtension:@"json"];
    
    // Load JSON data from file.
    NSError *__autoreleasing readFileError = nil;
    NSData *testData = [NSData dataWithContentsOfURL:testDataURL options:kNilOptions error:&readFileError];
    NSAssert(testData, @"Failed to load JSON test data. Error: %@", [readFileError localizedDescription]);
    
    // Parse JSON data to a Foundation object.
    NSError *__autoreleasing parseJSONError = nil;
    id JSONObject = [NSJSONSerialization JSONObjectWithData:testData options:kNilOptions error:&parseJSONError];
    NSAssert(JSONObject, @"Failed to parse JSON. Error: %@", [parseJSONError localizedDescription]);
    
    return JSONObject;
}

@end
