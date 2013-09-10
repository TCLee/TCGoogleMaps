//
//  TCAppDelegate.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/17/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCAppDelegate.h"
#import "TCGoogleAPIKeys.h"

@implementation TCAppDelegate

// Override point for customization after application launch.
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GMSServices provideAPIKey:kTCGoogleMapsAPIKey];
        
    return YES;
}

@end
