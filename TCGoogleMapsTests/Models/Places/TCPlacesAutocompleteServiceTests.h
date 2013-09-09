//
//  TCPlacesServiceTests.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/3/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class TCPlacesService;
@class TCPlacesAutocompleteParameters;

@interface TCPlacesAutocompleteServiceTests : SenTestCase

@property (nonatomic, strong) TCPlacesService *service;
@property (nonatomic, strong) TCPlacesAutocompleteParameters *parameters;

@end
