//
//  TCGooglePlacesAPI.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/20/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#pragma mark - TCGooglePlacesAutocomplete

/*
 This model represents the response returned from Google Places API:
 Places Autocomplete request.
 */
@interface TCGooglePlacesAutocomplete : NSObject

/* Contains the human-readable name for the returned result. */
@property (nonatomic, copy, readonly) NSString *description;

/*
 Contains a unique token that you can use to retrieve additional information
 about this place in a Place Details request.
 */
@property (nonatomic, copy, readonly) NSString *reference;

@end

#pragma mark - TCGooglePlace

/*
 This model represents the response returned from Google Places API:
 Place Details request.
 */
@interface TCGooglePlace : NSObject

/*
 ID and reference is used by Google Places API to identify a Place.
 */
@property (nonatomic, copy, readonly) NSString *ID;
@property (nonatomic, copy, readonly) NSString *reference;

/*
 Contains the human-readable name for the returned result.
 For establishment results, this is usually the canonicalized business name.
 */
@property (nonatomic, copy, readonly) NSString *name;

/* The geocoded latitude and longitude value for this place. */
@property (nonatomic, assign, readonly) CLLocationCoordinate2D coordinate;

/*
 Contains the URL of a suggested icon which may be displayed to the user
 when indicating this result on a map.
 */
@property (nonatomic, copy, readonly) NSURL *iconURL;

/* A string containing the human-readable address of this place. */
@property (nonatomic, copy, readonly) NSString *formattedAddress;

/* A string containing the simplified address of the place. */
@property (nonatomic, copy, readonly) NSString *vicinity;

/*
 Contains the Place's phone number in international format.
 International format includes the country code, and is prefixed with the
 plus (+) sign. For example, Google's Sydney, Australia office is +61 2 9374 4000.
 */
@property (nonatomic, copy, readonly) NSString *internationalPhoneNumber;

@end

#pragma mark - TCGooglePlacesAPI

/*
 Facade pattern to provide easy access to Google Places API.
 */
@interface TCGooglePlacesAPI : NSObject

/*
 Returns the shared object to access Google Places API.
 */
+ (TCGooglePlacesAPI *)sharedAPI;

/*
 Returns a list of place suggestions based on text search terms 
 and geographic bounds.
 */
- (void)placesAutocompleteForInput:(NSString *)input
                          location:(CLLocationCoordinate2D)coordinate
                            radius:(CLLocationDistance)radius
                        completion:(void (^)(NSArray *results, NSError *error))completion;

/*
 Returns the place details from the given reference. The reference can be 
 retrieved from the search results.
 */
- (void)placeDetailsWithReference:(NSString *)reference
                       completion:(void (^)(TCGooglePlace *placeDetails, NSError *error))completion;

@end
