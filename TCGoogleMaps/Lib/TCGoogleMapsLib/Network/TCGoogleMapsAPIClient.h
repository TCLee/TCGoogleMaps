//
//  TCGoogleMapsAPIClient.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/21/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

/**
 * Callback block for when Google Maps API services has returned with a 
 * success or failed response.
 *
 * @param operation the AFHTTPRequestOperation that was used to make the request
 * @param responseObject the object parsed from the JSON response. The object will be nil on failure.
 * @param error the `NSError` object describing why the API request failed. It will be nil on success.
 */
typedef void (^TCGoogleMapsAPIClientCallback)(AFHTTPRequestOperation *operation, id responseObject, NSError *error);

/**
 * Subclass of AFHTTPClient to access Google Maps services.
 */
@interface TCGoogleMapsAPIClient : AFHTTPClient

/**
 * Convenience method to return a default instance of the API client to 
 * access Google Maps APIs.
 */
+ (instancetype)defaultClient;

/**
 * Similar to AFHTTPClient's getPath:parameters:success:failure: method.
 * Except that it returns a AFHTTPRequestOperation, so that it can be cancelled.
 * 
 * @see AFHTTPClient#-getPath:parameters:success:failure:
 */
- (AFHTTPRequestOperation *)getPath:(NSString *)path
                         parameters:(NSDictionary *)parameters
                         completion:(TCGoogleMapsAPIClientCallback)completion;

@end
