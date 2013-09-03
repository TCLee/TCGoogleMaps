//
//  TCMapViewController.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/17/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCMapViewController.h"
#import "TCStepsViewController.h"
#import "TCGooglePlacesAPI.h"

#import "TCDirections.h"

@interface TCMapViewController ()

/* Google Map view. */
@property (nonatomic, weak) IBOutlet GMSMapView *mapView;

/* Place Details response returned from Google Places API. */
@property (nonatomic, strong) TCGooglePlace *placeDetails;

/* Route response returned from Google Directions API. */
@property (nonatomic, strong) TCDirectionsRoute *route;

@end

#pragma mark -

@implementation TCMapViewController

#pragma mark - View Events

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Tell Google Map to draw the user's current location.
    self.mapView.myLocationEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Show the navigation bar so that we can navigate back to search view.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
//    // If we have a valid Google Places reference, we will fetch the details for the place.
//    if (self.placeReference) {
//        [self getPlaceDetailsWithReference:self.placeReference];        
//    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // If we have a valid Google Places reference, we will fetch the details for the place.
    if (self.placeReference) {
        [self getPlaceDetailsWithReference:self.placeReference];
    }
}

#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showTextDirections"]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        TCStepsViewController *directionsViewController = (TCStepsViewController *)navigationController.topViewController;                
        directionsViewController.route = self.route;
    }
}

#pragma mark - Google Places API

- (void)getPlaceDetailsWithReference:(NSString *)reference
{
    // Get the place's details with the given reference.
    [[TCGooglePlacesAPI sharedAPI] placeDetailsWithReference:self.placeReference completion:^(TCGooglePlace *placeDetails, NSError *error) {
        if (placeDetails) {
            self.placeDetails = placeDetails;

            // Get the directions starting from user's current location and ending at place's location.
            CLLocationCoordinate2D originCoordinate = self.mapView.myLocation.coordinate;
            CLLocationCoordinate2D destinationCoordinate = self.placeDetails.coordinate;
            [self getDirectionsFromOrigin:originCoordinate toDestination:destinationCoordinate];
            
            // Create a marker for the place.
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = destinationCoordinate;
            marker.title = self.placeDetails.name;
            marker.snippet = self.placeDetails.vicinity;
            marker.map = self.mapView;
        } else {
            NSLog(@"Google Place Details API Error: %@", [error localizedDescription]);
        }
    }];
}

#pragma mark - Google Directions API

- (void)getDirectionsFromOrigin:(CLLocationCoordinate2D)origin toDestination:(CLLocationCoordinate2D)destination
{
    // Configure the parameters to be send to TCDirectionsService.
    TCDirectionsParameters *parameters = [[TCDirectionsParameters alloc] init];
    parameters.origin = origin;
    parameters.destination = destination;
    parameters.travelMode = TCTravelModeDriving;
    
    [[TCDirectionsService sharedService] routeWithParameters:parameters completion:^(NSArray *routes, NSError *error) {
        if (routes) {
            // There should only be one route since we did not ask for alternative routes.
            self.route = routes[0];
            
            // Move camera viewport to fit the viewport bounding box of this route.
            GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate fitBounds:self.route.bounds];
            [self.mapView animateWithCameraUpdate:cameraUpdate];

            // Draw the route on the map view.
            GMSPolyline *polyline = [GMSPolyline polylineWithPath:self.route.overviewPath];
            polyline.strokeWidth = 10.0f;
            polyline.map = self.mapView;
        } else {
            NSLog(@"Google Directions API Error: %@", [error localizedDescription]);
        }
    }];
}

@end
