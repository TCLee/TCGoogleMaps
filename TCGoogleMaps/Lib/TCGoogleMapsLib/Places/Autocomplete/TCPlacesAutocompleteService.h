//
//  TCPlacesAutocompleteService.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/9/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TCPlacesServiceBlocks.h"

@class TCPlacesAutocompleteParameters;

@interface TCPlacesAutocompleteService : NSObject

- (void)placePredictionsWithParameters:(TCPlacesAutocompleteParameters *)parameters completion:(TCPlacesAutocompleteServiceCallback)completion;

@end
