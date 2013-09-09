//
//  TCPlacesService_Private.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/8/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCPlacesService.h"

@class TCGoogleMapsAPIClient;

@interface TCPlacesService ()

/**
 * A custom `TCGoogleMapsAPIClient` instance that will be used to send
 * HTTP requests to Google Maps APIs. This allows us to set a mock API 
 * client that doesn't connect to the network for unit testing.
 * If this property is nil, then the default `TCGoogleMapsAPIClient`
 * shared instance will be used.
 */
@property (nonatomic, strong) TCGoogleMapsAPIClient *APIClient;

@end
