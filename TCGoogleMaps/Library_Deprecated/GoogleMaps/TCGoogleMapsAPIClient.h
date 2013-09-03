//
//  TCGoogleMapsAPIClient.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/21/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "AFHTTPClient.h"

@interface TCGoogleMapsAPIClient : AFHTTPClient

+ (TCGoogleMapsAPIClient *)sharedClient;

- (AFHTTPRequestOperation *)getPath:(NSString *)path
                         parameters:(NSDictionary *)parameters
                         completion:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSError *error))completion;

@end
