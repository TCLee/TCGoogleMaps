//
//  TCPlacesService.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/3/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCPlacesService.h"
#import "TCGoogleMapsAPIClient.h"

@implementation TCPlacesService

+ (TCPlacesService *)sharedService
{
    static TCPlacesService *_sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedService = [[TCPlacesService alloc] init];
    });    
    return _sharedService;
}

- (void)placePredictionsWithParameters:(TCPlacesAutocompleteParameters *)parameters
                            completion:(TCPlacesAutocompleteServiceCallback)completion
{
    NSParameterAssert(parameters);
    NSParameterAssert(completion);
    
    TCGoogleMapsAPIClient *client = self.APIClient ? self.APIClient : [TCGoogleMapsAPIClient sharedClient];
    [client getPath:@"" parameters:[parameters dictionary] completion:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        //TODO: Parse the response object to create prediction objects.
        completion(responseObject, error);
    }];        
}

@end
