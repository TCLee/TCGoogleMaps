//
//  TCMapViewController.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/17/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCMapViewController.h"
#import "TCStepsViewController.h"

#import "TCGooglePlaces.h"
#import "TCGoogleDirections.h"

@interface TCMapViewController ()

@property (nonatomic, weak) IBOutlet GMSMapView *mapView;
@property (nonatomic, weak) IBOutlet UIView *routeDetailsView;
@property (nonatomic, weak) IBOutlet UILabel *routeNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceAndDurationLabel;

/* Place Details result returned from Google Places API. */
@property (nonatomic, strong) TCPlace *place;

/* Route result returned from Google Directions API. */
@property (nonatomic, strong) TCDirectionsRoute *route;

@end

#pragma mark -

@implementation TCMapViewController

#pragma mark - View Events

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Show the navigation bar so that we can navigate back to search view.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // Hide the route details view, until we have a route to show.
    self.routeDetailsView.alpha = 0.0f;
    
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
        
        // Make sure we have a valid route that has at least one leg.
        if (self.route && [self.route.legs count] > 0) {
            // Since we did not specify any waypoints, the route will only
            // have one leg.
            TCDirectionsLeg *leg = self.route.legs[0];
            directionsViewController.steps = leg.steps;            
        }
    }
}

#pragma mark - Google Places API

- (void)getPlaceDetailsWithReference:(NSString *)reference
{    
    [[TCPlacesService sharedService] placeDetailsWithReference:reference completion:^(TCPlace *place, NSError *error) {
        if (place) {
            self.place = place;
            [self createMarkerForPlace:self.place onMap:self.mapView];
            
            if (self.myLocation) {
                [self createMarkerForMyLocation:self.myLocation
                                          onMap:self.mapView];
                [self getDirectionsFromMyLocation:self.myLocation
                                          toPlace:self.place];
            }
        } else {
            NSLog(@"[Google Place Details API] - Error : %@", [error localizedDescription]);
        }
    }];
}

- (void)createMarkerForPlace:(TCPlace *)place onMap:(GMSMapView *)mapView
{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = place.location;
    marker.title = place.name;
    marker.snippet = place.address;
    marker.map = mapView;
}

- (void)createMarkerForMyLocation:(CLLocation *)myLocation onMap:(GMSMapView *)mapView
{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
    marker.position = myLocation.coordinate;
    marker.title = @"My Location";
    marker.map = mapView;    
}

#pragma mark - Google Directions API

- (void)getDirectionsFromMyLocation:(CLLocation *)myLocation toPlace:(TCPlace *)place
{
    // Configure the parameters to be send to TCDirectionsService.
    TCDirectionsParameters *parameters = [[TCDirectionsParameters alloc] init];
    parameters.origin = self.myLocation.coordinate;
    parameters.destination = place.location;
    
    [[TCDirectionsService sharedService] routeWithParameters:parameters completion:^(NSArray *routes, NSError *error) {
        if (routes) {
            // There should only be one route since we did not ask for alternative routes.
            self.route = routes[0];
            
            // Move camera viewport to fit the viewport bounding box of this route.
            GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate fitBounds:self.route.bounds];
            [self.mapView animateWithCameraUpdate:cameraUpdate];
            
            [self drawRoute:self.route onMap:self.mapView];
            [self showRouteDetailsViewWithRoute:self.route];
        } else {
            NSLog(@"[Google Directions API] - Error: %@", [error localizedDescription]);
        }
    }];
}

- (void)drawRoute:(TCDirectionsRoute *)route onMap:(GMSMapView *)mapView
{
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:route.overviewPath];
    polyline.strokeWidth = 10.0f;
    polyline.map = mapView;
}

- (void)showRouteDetailsViewWithRoute:(TCDirectionsRoute *)route
{
    self.routeNameLabel.text = route.summary;
    
    // With no waypoints, we only have one leg.
    TCDirectionsLeg *leg = route.legs[0];
    self.distanceAndDurationLabel.text = [NSString stringWithFormat:@"%@, %@",
                                          leg.distance.text, leg.duration.text];
    
    // Fade in animation for the route details view.
    [UIView animateWithDuration:1.0f animations:^{
        self.routeDetailsView.alpha = 1.0f;
    }];
}

@end
