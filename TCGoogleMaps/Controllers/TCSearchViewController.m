//
//  TCSearchViewController.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/19/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCSearchViewController.h"
#import "TCMapViewController.h"
#import "TCUserLocationManager.h"
#import "TCGooglePlaces.h"

#import <MBProgressHUD/MBProgressHUD.h>

@interface TCSearchViewController ()

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *placePredictions;

@property (nonatomic, strong, readonly) TCUserLocationManager *userLocationManager;
@property (nonatomic, strong) CLLocation *myLocation;

@end

// Google Places Autocomplete API uses the radius to determine the area to search places in.
static CLLocationDistance const kSearchRadiusInMeters = 15000.0f;

@implementation TCSearchViewController

@synthesize userLocationManager = _userLocationManager;

#pragma mark - User Location Manager

- (TCUserLocationManager *)userLocationManager
{
    if (!_userLocationManager) {
        _userLocationManager = [[TCUserLocationManager alloc] init];
    }
    return _userLocationManager;
}

#pragma mark - View Events

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // Hide the navigation bar for the search view.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // Show progress HUD while we find the user's location.
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.dimBackground = YES;
    progressHUD.labelText = @"Finding My Location";
    
    // Make progress HUD consume all touches to disable interaction on
    // background views.
    progressHUD.userInteractionEnabled = YES;
    
    // Get the user's current location. Google Places API uses the user's
    // current location to find relevant places.
    [self.userLocationManager startLocatingUserWithCompletion:^(CLLocation *userLocation, NSError *error) {
        if (userLocation) {
            self.myLocation = userLocation;
            [progressHUD hide:YES];
            
            // Set focus to the UISearchBar, so that user can start
            // entering their query right away.
            [self.searchBar becomeFirstResponder];
        } else {
            NSLog(@"[TCUserLocationManager] - Error: %@", [error localizedDescription]);
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Stop location services when this view disappears to save power consumption.
    [self.userLocationManager stopLocatingUser];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    self.placePredictions = nil;
}

#pragma mark - UISearchBar Delegate

/*
 While user types in the search field, we will asynchronously fetch a list 
 of place suggestions.
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // If user deleted the search text, we should not waste resources sending an
    // empty input string to Google Places Autocomplete API.
    if (nil == searchText || 0 == [searchText length]) {
        self.placePredictions = nil;
        [self.tableView reloadData];
        return;
    }
    
    // Request parameters to be send to Google Places Autocomplete API.
    TCPlacesAutocompleteParameters *parameters = [[TCPlacesAutocompleteParameters alloc] init];
    parameters.input = searchText;
    parameters.location = self.myLocation.coordinate;
    parameters.radius = kSearchRadiusInMeters;
    
    // Asynchronously fetches the place autocomplete predictions from user's search text.
    [[TCPlacesService sharedService] placePredictionsWithParameters:parameters completion:^(NSArray *predictions, NSError *error) {
        // It is possible that the UISearchBar's text has changed when we return
        // from the network with the results. If it has changed, we should not
        // display stale results on the table view.
        if (predictions && [parameters.input isEqualToString:searchBar.text]) {
            self.placePredictions = predictions;
            [self.tableView reloadData];
            return;
        }
        
        // Google Places Autocomplete API error handling.
        if (error) {
            if (NSURLErrorCancelled == error.code) {
                NSLog(@"[Google Places Autocomplete API] - Cancelled request for input \"%@\".", parameters.input);
            } else {
                NSString *statusCode = error.userInfo[TCPlacesServiceStatusCodeErrorKey];
                NSString *description = [error localizedDescription];
                
                if (statusCode) {
                    NSLog(@"[Google Places Autocomplete API] - Status Code: %@, Error: %@", statusCode, description);
                } else {
                    NSLog(@"[Google Places Autocomplete API] - Error: %@", description);
                }
            }
        }
    }];        
}

#pragma mark - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.placePredictions) {
        return 0;
    }

    return [self.placePredictions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const CellIdentifier = @"SearchResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    TCPlacesAutocompletePrediction *prediction = self.placePredictions[indexPath.row];
    cell.textLabel.text = prediction.description;    
    return cell;
}

#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showMap"]) {
        // Get the selected place.
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        TCPlacesAutocompletePrediction *prediction = self.placePredictions[selectedIndexPath.row];
        
        // Display it on the map with directions.
        TCMapViewController *mapViewController = (TCMapViewController *) [segue destinationViewController];
        mapViewController.myLocation = self.myLocation;
        mapViewController.placeReference = prediction.reference;
    }
}

@end
