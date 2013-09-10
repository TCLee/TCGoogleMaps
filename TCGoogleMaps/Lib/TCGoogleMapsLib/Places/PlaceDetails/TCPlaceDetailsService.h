//
//  TCPlaceDetailsService.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/9/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TCPlacesServiceBlocks.h"

@interface TCPlaceDetailsService : NSObject

- (void)placeDetailsWithReference:(NSString *)reference completion:(TCPlaceDetailsServiceCallback)completion;

@end
