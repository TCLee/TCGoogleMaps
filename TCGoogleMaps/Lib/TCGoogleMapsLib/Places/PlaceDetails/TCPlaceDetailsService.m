//
//  TCPlaceDetailsService.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/9/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCPlaceDetailsService.h"
#import "TCPlace.h"
#import "TCPlacesServiceStatusCode.h"
#import "TCPlacesServiceError.h"
#import "TCGooglePlacesAPIClient.h"

@interface TCPlaceDetailsService ()

@property (nonatomic, strong) AFHTTPRequestOperation *placesDetailsRequest;

@end

@implementation TCPlaceDetailsService

- (void)placeDetailsWithReference:(NSString *)reference completion:(TCPlaceDetailsServiceCallback)completion
{
    // Cancel previous request (if any) before we begin a new one.
    [self.placesDetailsRequest cancel];
    
    self.placesDetailsRequest = [[TCGooglePlacesAPIClient defaultClient] getPath:@"details/json" parameters:@{@"reference": reference} completion:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        if (responseObject) {
            ParseResponse(responseObject, completion);
        } else {
            Callback(completion, nil, error);
        }
    }];
}

FOUNDATION_STATIC_INLINE void Callback(TCPlaceDetailsServiceCallback block, id place, NSError *error)
{
    if (block) {
        block(place, error);
    }
}

static void ParseResponse(NSDictionary *response, TCPlaceDetailsServiceCallback completion)
{
    NSString *statusCode = response[@"status"];
    if ([statusCode isEqualToString:TCPlacesServiceStatusOK]) {
        TCPlace *place = [[TCPlace alloc] initWithProperties:response[@"result"]];
        Callback(completion, place, nil);
    } else {
        Callback(completion, nil, [TCPlacesServiceError errorWithStatusCode:statusCode]);
    }
}

@end
