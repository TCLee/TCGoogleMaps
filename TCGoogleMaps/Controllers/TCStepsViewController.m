//
//  TCDirectionsViewController.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/22/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCStepsViewController.h"
#import "TCGoogleDirections.h"

@interface TCStepsViewController ()

/* The leg of the route that contains the set of steps. 
   Since the route contains no waypoints, the route will only 
   have a single leg. */
@property (nonatomic, strong) TCDirectionsLeg *leg;

/* Dismiss this modal view controller. */
- (IBAction)dismiss:(id)sender;

@end

#pragma mark -

@implementation TCStepsViewController

#pragma mark View Events

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark TCDirectionsRoute

- (void)setRoute:(TCDirectionsRoute *)route
{
    if (_route != route) {
        _route = route;
        
        // The route consists of only one leg, since we have no waypoints.
        self.leg = route.legs[0];
    }
}

#pragma mark Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.route) {
        return 0;
    }
    
    return [self.leg.steps count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const CellIdentifier = @"TCDirectionsStepCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];    
    
    TCDirectionsStep *step = self.leg.steps[indexPath.row];
    cell.textLabel.text = step.instructions;
    cell.detailTextLabel.text = step.distance.text;
    return cell;
}

#pragma mark Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO: Dynamically calculate height of table row.
    return 80.0f;
}

#pragma mark IBAction

/*
 User press the Done button to dismiss this modal view controller.
 */
- (IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
