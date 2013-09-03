//
//  TCSearchViewController.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/19/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCSearchViewController.h"
#import "TCMapViewController.h"
#import "TCGooglePlacesAPI.h"

@interface TCSearchViewController ()

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *autocompleteResults;

@property (nonatomic, strong, readonly) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *myLocation;

@end

// Google Places Autocomplete API uses the radius to determine the area to search places in.
static CLLocationDistance const kRadiusInMeters = 15000.0f;

@implementation TCSearchViewController

@synthesize locationManager = _locationManager;

#pragma mark - View Events

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // Hide the navigation bar for the search view.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // Get the user's current location. Google Places API uses the user's
    // current location to find relevant places.
    [self startLocatingUser];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
        
    // Set focus to the UISearchBar, so that user can start
    // entering their query right away.
    [self.searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Stop location services when this view disappears to save power consumption.
    [self stopLocatingUser];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    self.autocompleteResults = nil;
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
    if (!searchText || 0 == [searchText length]) {
        self.autocompleteResults = nil;
        [self.tableView reloadData];
        return;
    }
    
    // Fetch a list of suggested places for the user's text input.
    [[TCGooglePlacesAPI sharedAPI] placesAutocompleteForInput:searchText location:self.myLocation.coordinate radius:kRadiusInMeters completion:^(NSArray *results, NSError *error) {
        if (error) {
            if ([error code] == NSURLErrorCancelled) {
                NSLog(@"Google Places Autocomplete API cancelled for input \"%@\"", searchText);
            } else {
                NSLog(@"Google Places Autocomplete API Error: %@", [error localizedDescription]);
            }
        } else if (results) {
            // It is possible that the UISearchBar's text has changed when we return
            // from the network with the results. If it has changed, we should not
            // display stale results on the table view.
            if ([searchText isEqualToString:searchBar.text]) {
                self.autocompleteResults = results;
                [self.tableView reloadData];
            }
        }
    }];
}

#pragma mark - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.autocompleteResults) {
        return 0;
    }

    return [self.autocompleteResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const CellIdentifier = @"SearchResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    TCGooglePlacesAutocomplete *autocomplete = self.autocompleteResults[indexPath.row];
    cell.textLabel.text = autocomplete.description;
    return cell;
}

#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showMap"]) {
        // Get the selected place.
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        TCGooglePlacesAutocomplete *autocomplete = self.autocompleteResults[selectedIndexPath.row];
        
        // Display it on the map with directions.
        TCMapViewController *mapViewController = (TCMapViewController *) [segue destinationViewController];
        mapViewController.placeReference = autocomplete.reference;
    }
}

#pragma mark - Location Services

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (void)startLocatingUser
{
    NSLog(@"Start Locating User");
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager startUpdatingLocation];
}

- (void)stopLocatingUser
{
    NSLog(@"Stop Locating User");
    
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    
    // We don't want a cached location that is too out of date.
    NSTimeInterval locationAge = abs([newLocation.timestamp timeIntervalSinceNow]);
    if (locationAge > 15.0f) { return; }
    
    // Horizontal accuracy returns a negative value to indicate that the location's
    // longitude and latitude are invalid.
    if (newLocation.horizontalAccuracy < 0) { return; }
    
    // Only save the new location if it's more accurate than previous locations.
    if (nil == self.myLocation || self.myLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        self.myLocation = newLocation;
        
        // If we have a measurement that meets our requirements, we can stop updating the location.
        if (newLocation.horizontalAccuracy <= self.locationManager.desiredAccuracy) {
            [self stopLocatingUser];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] != kCLErrorLocationUnknown) {
        NSLog(@"CLLocationManager Error: %@", [error localizedDescription]);
    }    
}

@end
