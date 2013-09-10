//
//  TCGooglePlacesAPIClient.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/10/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TCGoogleMapsAPIClient.h"

@interface TCGooglePlacesAPIClient : TCGoogleMapsAPIClient

+ (TCGooglePlacesAPIClient *)sharedClient;

@end
