//
//  TCMapViewController.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/17/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

#import "TCGooglePlaces.h"
#import "TCGoogleDirections.h"

#import "TCMapViewController.h"
#import "TCStepsViewController.h"

@interface TCMapViewController ()

/** Google Maps view. */
@property (nonatomic, weak) IBOutlet GMSMapView *mapView;

/**
 * Labels to display the route's name, distance and duration.
 */
@property (nonatomic, weak) IBOutlet UIView *routeDetailsView;
@property (nonatomic, weak) IBOutlet UILabel *routeNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceAndDurationLabel;

/**
 * A unique token that you can use to retrieve additional information
 * about this place in a Place Details request.
 */
@property (nonatomic, copy, readonly) NSString *placeReference;

/** The user's current location. */
@property (nonatomic, strong, readonly) CLLocation *myLocation;

/** Place Details result returned from Google Places API. */
@property (nonatomic, strong) TCPlace *place;

/** Route result returned from Google Directions API. */
@property (nonatomic, strong) TCDirectionsRoute *route;

/** The marker for the step's location. */
@property (nonatomic, strong) GMSMarker *stepMarker;

/** The marker that represents the destination. */
@property (nonatomic, strong) GMSMarker *destinationMarker;

@end

@implementation TCMapViewController

#pragma mark - Models

- (void)setMyLocation:(CLLocation *)myLocation placeReference:(NSString *)aPlaceReference
{
    // Update my location, only if it has changed.
    if (_myLocation != myLocation) {
        _myLocation = [myLocation copy];
    }
    
    // Only fetch new place details from Google Places API, if place's
    // reference has changed.
    if (_placeReference != aPlaceReference) {
        _placeReference = [aPlaceReference copy];                
        [self getPlaceDetailsWithReference:_placeReference];
    }
}

#pragma mark - View Events

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Tell Google Maps to draw the user's location on the map view.
    self.mapView.myLocationEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Show the navigation bar so that we can navigate back to search view.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowDirectionsSteps"]) {
        // Steps view controller is contained in a navigation controller.
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        TCStepsViewController *stepsViewController = (TCStepsViewController *)navigationController.topViewController;
        stepsViewController.delegate = self;
        
        // Make sure we have a route that has at least one leg.
        if (self.route && [self.route.legs count] > 0) {
            // Since we did not specify any waypoints, the route will only
            // have one leg.
            TCDirectionsLeg *leg = self.route.legs[0];
            
            // Pass the array of steps and the place details of the destination.
            [stepsViewController setSteps:leg.steps destination:self.place];
        }
    }
}

#pragma mark - Google Places API

- (void)getPlaceDetailsWithReference:(NSString *)reference
{    
    [[TCPlacesService sharedService] placeDetailsWithReference:reference completion:^(TCPlace *place, NSError *error) {
        if (place) {
            self.place = place;
            
            // Create marker for the destination on the map view.
            self.destinationMarker = [self createMarkerForPlace:self.place onMap:self.mapView];

            // Focus camera on destination.
            [self.mapView animateWithCameraUpdate:
             [GMSCameraUpdate setTarget:self.destinationMarker.position]];
            
            // Request Google Directions API for directions starting from
            // my location to destination.
            if (self.myLocation) {
                [self getDirectionsFromMyLocation:self.myLocation
                                          toPlace:self.place];
            }
        } else {
            NSLog(@"[Google Place Details API] - Error : %@", [error localizedDescription]);
        }
    }];
}

- (GMSMarker *)createMarkerForPlace:(TCPlace *)place onMap:(GMSMapView *)mapView
{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = place.location;
    marker.title = place.name;
    marker.snippet = place.address;
    marker.map = mapView;
    
    return marker;
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
            [self.mapView animateWithCameraUpdate:
             [GMSCameraUpdate fitBounds:self.route.bounds]];
            
            [self drawRoute:self.route onMap:self.mapView];
            [self showRouteDetailsViewWithRoute:self.route];
            
            // With a valid route, we can now allow user to view the step-by-step instructions.
            self.navigationItem.rightBarButtonItem.enabled = YES;
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
    self.routeDetailsView.alpha = 0.0f;
    [UIView animateWithDuration:1.0f animations:^{
        self.routeDetailsView.alpha = 1.0f;
    }];
}

#pragma mark - TCStepsViewController Delegate

- (void)stepsViewControllerDidSelectMyLocation:(TCStepsViewController *)stepsViewController
{
    // Passing in nil to selectMarker will deselect any currently selected marker.
    [self mapView:self.mapView setCameraTarget:self.myLocation.coordinate selectMarker:nil];
}

- (void)stepsViewControllerDidSelectDestination:(TCStepsViewController *)stepsViewController
{
    [self mapView:self.mapView setCameraTarget:self.destinationMarker.position selectMarker:self.destinationMarker];
}

- (void)stepsViewController:(TCStepsViewController *)stepsViewController didSelectStep:(TCDirectionsStep *)step
{    
    // Zoom in to fit the step's path.
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:step.path];
    [self.mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds]];
    
    // Remove any previous step's marker from the map.
    self.stepMarker.map = nil;
    
    // Create marker to represent the start of the step.
    self.stepMarker = [self createMarkerForStep:step onMap:self.mapView];
    
    // Select the step marker to show its info window.
    self.mapView.selectedMarker = self.stepMarker;    
    [self.mapView animateToLocation:self.stepMarker.position];
}

- (GMSMarker *)createMarkerForStep:(TCDirectionsStep *)step onMap:(GMSMapView *)mapView
{
    GMSMarker *marker = [GMSMarker markerWithPosition:step.startLocation];
    marker.icon = [self stepMarkerIcon];
    marker.snippet = step.instructions;
    marker.map = self.mapView;
    
    return marker;
}

/**
 * Returns the image used for the selected step's marker icon.
 */
- (UIImage *)stepMarkerIcon
{
    // Here we are just creating a 1x1 transparent image to be used for
    // the marker icon. Thus, making the marker icon invisible.    
    static UIImage * _image = nil;
    if (!_image) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(1.0f, 1.0f), NO, 0.0f);
        _image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _image;
}

/**
 * Zooms the camera in at given coordinate and selects the marker to open 
 * its info window.
 *
 * @param mapView    The GMSMapView instance.
 * @param coordinate The coordinate to focus camera on.
 * @param marker     The marker to select on the mapView.
 */
- (void)mapView:(GMSMapView *)mapView setCameraTarget:(CLLocationCoordinate2D)coordinate selectMarker:(GMSMarker *)marker
{
    // Show the info window of the selected marker.
    mapView.selectedMarker = marker;
    
    // Zoom in to focus on target location.
    [mapView animateWithCameraUpdate:
     [GMSCameraUpdate setTarget:coordinate zoom:17.0f]];
}

@end
